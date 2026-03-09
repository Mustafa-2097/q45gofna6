import 'package:get/get.dart';

class EventModel {
  final String imageUrl;
  final String status; // 'Active' or 'Completed'
  final String title;
  final String date;
  final String items;
  final String price;
  final String footerText;
  final bool hasIssue; // red footer (missing items) vs info footer (baseline)

  EventModel({
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.date,
    required this.items,
    required this.price,
    required this.footerText,
    required this.hasIssue,
  });
}

class EventController extends GetxController {
  final tabs = ['All', 'Active', 'Completed'].obs;
  final selectedTab = 'All'.obs;

  final allEvents = <EventModel>[
    EventModel(
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=800&auto=format&fit=crop',
      status: 'Completed',
      title: 'Corporate Conference 2026',
      date: 'Feb 15',
      items: '4 items',
      price: '\$3,480',
      footerText: '1 items missing',
      hasIssue: true,
    ),
    EventModel(
      imageUrl:
          'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=800&auto=format&fit=crop',
      status: 'Active',
      title: 'Product Launch Event',
      date: 'Mar 5',
      items: '5 items',
      price: '\$4,280',
      footerText: 'Baseline captured',
      hasIssue: false,
    ),
  ].obs;

  List<EventModel> get filteredEvents {
    final tab = selectedTab.value;
    if (tab == 'All') return allEvents;
    return allEvents.where((e) => e.status == tab).toList();
  }

  int get totalCount => allEvents.length;
  int get activeCount => allEvents.where((e) => e.status == 'Active').length;
  int get doneCount => allEvents.where((e) => e.status == 'Completed').length;

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}
