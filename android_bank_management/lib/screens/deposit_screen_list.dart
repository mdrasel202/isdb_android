import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/bank_deposit_response.dart';
import '../service/bank_deposit_service.dart';

class AllDepositListScreen extends StatefulWidget {
  @override
  _AllDepositListScreenState createState() => _AllDepositListScreenState();
}

class _AllDepositListScreenState extends State<AllDepositListScreen> {
  List<BankDepositResponseDTO> _deposits = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllDeposits();
  }

  Future<void> _loadAllDeposits() async {
    try {
      final deposits = await ApiDeposit.getAllDeposits();
      setState(() {
        _deposits = deposits;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load deposits';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Deposits')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _deposits.length,
        itemBuilder: (context, index) {
          final d = _deposits[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Account: ${d.accountNumber}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: \$${d.depositAmount.toStringAsFixed(2)}'),
                  Text('Status: ${d.bankDepositStatus}'),
                  Text('Date: ${d.depositDate}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}