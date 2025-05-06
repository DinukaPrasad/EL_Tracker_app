import 'package:eltracker_app/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final List<String> _deuPaymentCardList = ['1', '2', '3', '4', '5', '6'];
  int _touchedIndex = -1;

  // Define pie chart sections
  final List<PieChartSectionData> _loanSections = [
    _buildPieSection(40, Colors.blueAccent, 'Completed'),
    _buildPieSection(30, Colors.greenAccent, 'Active'),
    _buildPieSection(20, Colors.orangeAccent, 'Pending'),
    _buildPieSection(10, Colors.redAccent, 'Overdue'),
  ];

  final List<PieChartSectionData> _expenseSections = [
    _buildPieSection(35, Colors.purpleAccent, 'Utilities'),
    _buildPieSection(25, Colors.tealAccent, 'Rent'),
    _buildPieSection(20, Colors.amberAccent, 'Supplies'),
    _buildPieSection(20, Colors.deepOrangeAccent, 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Dashboard Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Summary Cards
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSummaryCard(
                  title: 'Loan Summary',
                  chart: _buildPieChart(sections: _loanSections),
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Expenses Summary',
                  chart: _buildPieChart(sections: _expenseSections),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Due Payments Header with action button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due Payments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Due Payments List
          Card(
            margin: const EdgeInsets.all(0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _deuPaymentCardList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: DeuPaymentCard(
                        cardCount: _deuPaymentCardList[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required Widget chart}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart({required List<PieChartSectionData> sections}) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections:
            sections.map((section) {
              final index = sections.indexOf(section);
              return section.copyWith(
                radius: _touchedIndex == index ? 50 : 40,
                titleStyle: TextStyle(
                  fontSize: _touchedIndex == index ? 16 : 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
      ),
    );
  }

  static PieChartSectionData _buildPieSection(
    double value,
    Color color,
    String title,
  ) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '$value%',
      radius: 40,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: _Badge(title, color.withValues()),
      badgePositionPercentageOffset: 1.2,
    );
  }
}

class _Badge extends StatelessWidget {
  final String title;
  final Color color;

  const _Badge(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
