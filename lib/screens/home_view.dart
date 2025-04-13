import 'package:eltracker_app/widgets/deu_payment_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  // ignore: non_constant_identifier_names
  final List _DeuPaymentCardList = [ '1','2','3','4','5','6'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* headline text
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text('Summary'),
        ),

        //*summary cards
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(                //*Loan summary
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                     color: Colors.amberAccent, 
                     borderRadius: BorderRadius.circular(10)
                    ),

                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: 10),
                          PieChartSectionData(value: 20),
                          PieChartSectionData(value: 30),
                          PieChartSectionData(value: 40),
                        ]
                      )
                    ), 
                  ),
                  Container(               //*Expenses summary
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                     color: Colors.amberAccent, 
                     borderRadius: BorderRadius.circular(10)
                    ),
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: 10),
                          PieChartSectionData(value: 20),
                          PieChartSectionData(value: 30),
                          PieChartSectionData(value: 40),
                        ]
                      )
                    ), 
                  ),
                  
                ],
              ),
        ),

        //* Deu list headline
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text('Deu Payments List'),
        ),

        //* Deu loan list view
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0 , right: 20.0, top: 10.0),
            child: ListView.builder(
              itemCount: _DeuPaymentCardList.length,
              itemBuilder: (context, index) {
                return DeuPaymentCard(cardCount: _DeuPaymentCardList[index],);
              },
            ),
          ),
        ),
      ],
    );
  }
}