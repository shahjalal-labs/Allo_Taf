import 'dart:developer';

import 'package:allo_taf/core/service/app_urls.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/service/network_caller.dart';
import 'package:get/get.dart';

import '../model/alert_model.dart';

class RecruiterAlertController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();

  final alertsList = <NotificationItem>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final unreadCount = 0.obs;
  final showOnlyUnread = false.obs;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 10;

  bool get hasMoreData => _currentPage < _totalPages;

  @override
  void onInit() {
    super.onInit();
    fetchAlerts();
    fetchUnreadCount();
  }

  Future<void> fetchAlerts({bool resetPage = true}) async {
    try {
      if (resetPage) {
        isLoading.value = true;
        _currentPage = 1;
      }

      final String url = showOnlyUnread.value
          ? AppUrls.allUnreadNotification('false', _currentPage, _limit)
          : AppUrls.notifications(_currentPage, _limit);

      final response = await networkCaller.getRequest(url);
      log("User ID: ${AuthService.id}");

      if (response.isSuccess && response.responseData != null) {
        final alertModel = NotificationResponseModel.fromJson(
          response.responseData,
        );

        if (alertModel.success == true && alertModel.result != null) {
          _totalPages = alertModel.result?.meta?.totalPages ?? 1;
          final fetchedData = alertModel.result?.data ?? [];

          if (resetPage) {
            alertsList.assignAll(fetchedData);
          } else {
            alertsList.addAll(fetchedData);
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreAlerts() async {
    if (isLoadingMore.value || !hasMoreData || isLoading.value) return;

    try {
      isLoadingMore.value = true;
      _currentPage++;

      final String url = showOnlyUnread.value
          ? AppUrls.allUnreadNotification('false', _currentPage, _limit)
          : AppUrls.notifications(_currentPage, _limit);

      final response = await networkCaller.getRequest(url);

      if (response.isSuccess && response.responseData != null) {
        final alertModel = NotificationResponseModel.fromJson(
          response.responseData,
        );

        if (alertModel.success == true && alertModel.result != null) {
          _totalPages = alertModel.result?.meta?.totalPages ?? _totalPages;
          final newItems = alertModel.result?.data ?? [];
          alertsList.addAll(newItems);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more notifications: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await networkCaller.getRequest(
        AppUrls.notificationUnreadCount(),
      );
      if (response.isSuccess && response.responseData != null) {
        final count =
            response.responseData['result']?['count'] ??
            response.responseData['data']?['count'] ??
            response.responseData['count'];
        if (count != null) {
          unreadCount.value = count is int
              ? count
              : int.parse(count.toString());
        }
      }
    } catch (_) {}
  }

  Future<void> toggleUnreadFilter(bool unreadOnly) async {
    if (showOnlyUnread.value == unreadOnly) return;
    showOnlyUnread.value = unreadOnly;
    await fetchAlerts(resetPage: true);
  }

  Future<void> markAsRead(NotificationItem alert) async {
    if (alert.id == null || alert.isRead == true) return;

    final index = alertsList.indexWhere((e) => e.id == alert.id);
    if (index != -1) {
      alertsList[index] = NotificationItem(
        id: alert.id,
        title: alert.title,
        body: alert.body,
        isRead: true,
        type: alert.type,
        notificationChannel: alert.notificationChannel,
        metaData: alert.metaData,
        sender: alert.sender,
        createdAt: alert.createdAt,
      );
      if (unreadCount.value > 0) unreadCount.value--;
      if (showOnlyUnread.value) {
        alertsList.removeAt(index);
      }
    }

    try {
      await networkCaller.getRequest(AppUrls.markAsRead(alert.id!));
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      alertsList.value = alertsList.map((alert) {
        return NotificationItem(
          id: alert.id,
          title: alert.title,
          body: alert.body,
          isRead: true,
          type: alert.type,
          notificationChannel: alert.notificationChannel,
          metaData: alert.metaData,
          sender: alert.sender,
          createdAt: alert.createdAt,
        );
      }).toList();

      unreadCount.value = 0;

      if (showOnlyUnread.value) {
        alertsList.clear();
      }

      final response = await networkCaller.patchRequest(
        AppUrls.markAllAsRead(),
        token: AuthService.token,
        body: {"isRead": true},
      );
      if (!response.isSuccess) {
        fetchAlerts(resetPage: true);
        fetchUnreadCount();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark all as read: $e');
      fetchAlerts(resetPage: true);
      fetchUnreadCount();
    }
  }

  Future<void> refreshAlerts() async {
    await fetchAlerts(resetPage: true);
    await fetchUnreadCount();
  }

  void handleAlertTap(NotificationItem alert) {
    markAsRead(alert);

    final deeplink = alert.metaData?.extra?.deeplink;
    if (deeplink != null && deeplink.isNotEmpty) {
      // Deeplink logic
    }
  }
}
