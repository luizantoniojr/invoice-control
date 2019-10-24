import 'package:flutter/material.dart';
import 'package:invoice_control/src/blocs/invoices_bloc.dart';
import 'package:invoice_control/src/models/invoice-result.dart';
import 'package:intl/intl.dart';

class Invoices extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;

  Invoices(this._invoiceBloc);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  void initState() {
    widget._invoiceBloc.init();
    widget._invoiceBloc.fetchAllInvoices();
    super.initState();
  }

  @override
  void dispose() {
    widget._invoiceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice Control")),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "Search"),
            ),
            Expanded(
                child: StreamBuilder(
              stream: widget._invoiceBloc.allInvoices,
              builder: (context, AsyncSnapshot<InvoiceResult> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.total,
                    itemBuilder: (BuildContext context, int index) {
                      return getInvoiceItem(snapshot, index);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ))
          ],
        ),
      ),
    );
  }

  ListTile getInvoiceItem(AsyncSnapshot<InvoiceResult> snapshot, int index) {
    final currencyFormat = new NumberFormat("#,##0.00", "pt_BR");

    var valueFormated =
        "R\$ ${currencyFormat.format(snapshot.data.results[index].value)}";

    return ListTile(
      title: Text(snapshot.data.results[index].description),
      subtitle: Text(valueFormated),
      trailing: Text(snapshot.data.results[index].dayDue.toString()),
    );
  }
}
