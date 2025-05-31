import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp = MaterialApp(
      title: 'Auditorium Seating',
      home: const SeatingScreen(),
      debugShowCheckedModeBanner: false,
    );

    return materialApp;
  }
}

class SeatingScreen extends StatefulWidget {
  const SeatingScreen({super.key});

  @override
  State<SeatingScreen> createState() => _SeatingScreenState();
}

class _SeatingScreenState extends State<SeatingScreen> {
  List<String> rows = ['A', 'B', 'C'];
  List<int> seatsPerRow = [5, 5, 5];
  Map<String, bool> bookedSeats = {};
  Set<String> selectedSeats = {};
  int totalBooked = 0;
  int totalAvailable = 15;
  double totalEarning = 0;
  Map<String, int> seatPrices = {'A': 800, 'B': 600, 'C': 500};

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text('Auditorium Seating'),
    );

    List<Widget> seatRows = [];

    for (int i = 0; i < rows.length; i++) {
      String rowLabel = rows[i];
      List<Widget> seats = [];

      for (int j = 0; j < seatsPerRow[i]; j++) {
        String seatNumber = '$rowLabel${j + 1}';
        bool isBooked = bookedSeats[seatNumber] ?? false;
        bool isSelected = selectedSeats.contains(seatNumber);

        Color backgroundColor = Colors.green[300]!;
        if (isBooked) {
          backgroundColor = Colors.red;
        } else if (isSelected) {
          backgroundColor = Colors.blue[200]!;
        }

        GestureDetector seat = GestureDetector(
          onTap: () {
            setState(() {
              if (selectedSeats.contains(seatNumber)) {
                selectedSeats.remove(seatNumber);
              } else {
                selectedSeats.add(seatNumber);
              }
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: Colors.black12),
            ),
            alignment: Alignment.center,
            child: Text(
              seatNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );

        seats.add(seat);
      }

      Row seatRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: seats,
      );

      seatRows.add(seatRow);
    }

    ElevatedButton bookButton = ElevatedButton(
      onPressed: selectedSeats.isNotEmpty
          ? () {
        setState(() {
          for (var seat in selectedSeats) {
            if (!bookedSeats.containsKey(seat)) {
              bookedSeats[seat] = true;
              totalBooked++;
              totalAvailable--;
              final row = seat[0];
              totalEarning += seatPrices[row]!;
            }
          }
          selectedSeats.clear();
        });
      }
          : null,
      child: const Text('Book'),
    );

    ElevatedButton releaseButton = ElevatedButton(
      onPressed: selectedSeats.isNotEmpty
          ? () {
        setState(() {
          for (var seat in selectedSeats) {
            if (bookedSeats.containsKey(seat)) {
              bookedSeats.remove(seat);
              totalBooked--;
              totalAvailable++;
              final row = seat[0];
              totalEarning -= seatPrices[row]!;
            }
          }
          selectedSeats.clear();
        });
      }
          : null,
      child: const Text('Release'),
    );

    Row buttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [bookButton, releaseButton],
    );

    Text bookedText = Text('Total no. of seats booked: $totalBooked');
    Text availableText = Text('Total no. of seats available: $totalAvailable');
    Text earningsText = Text('Total Earning Rs. $totalEarning');

    Column mainColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...seatRows,
        const SizedBox(height: 20),
        buttonRow,
        const SizedBox(height: 20),
        bookedText,
        availableText,
        earningsText,
      ],
    );

    Scaffold scaffold = Scaffold(
      appBar: appBar,
      body: mainColumn,
    );

    return scaffold;
  }
}
