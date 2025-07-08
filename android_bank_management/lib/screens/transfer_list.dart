import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/transaction.dart';
import '../service/transfer_service.dart';

class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late Future<List<Transaction>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = ApiTransfer.getAllTransactions(); // or getTransactionsByAccount(id)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final txs = snapshot.data!;
            return ListView.builder(
              itemCount: txs.length,
              itemBuilder: (context, index) {
                final tx = txs[index];
                return ListTile(
                  title: Text(tx.description),
                  subtitle: Text('Amount: ${tx.amount.toStringAsFixed(2)}'),
                  trailing: Text(tx.date),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}