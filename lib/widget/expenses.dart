import 'package:expense_tracker/chart/chart.dart';
import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widget/new_expenses.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/blueprint.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _MyExpenses();
  }
}

class _MyExpenses extends State<Expenses> {
  final List<Expense> _registered = [];

  void _openAddExpense() {
    showModalBottomSheet(
      // it is used to full screen the modal sheet
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registered.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registered.indexOf(expense);
    setState(() {
      _registered.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registered.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No Expenses Found. Start adding some!"),
    );

    if (_registered.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registered,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: _openAddExpense,
        //     icon: const Icon(Icons.add),
        //   )
        // ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registered),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registered),
                ),
                Expanded(child: mainContent),
              ],
            ),
      floatingActionButton: IconButton(
        onPressed: _openAddExpense,
        icon: const Icon(Icons.add),
        color: Colors.white,
        style: const ButtonStyle(
          iconSize: MaterialStatePropertyAll(40),
          backgroundColor: MaterialStatePropertyAll(
            Color.fromRGBO(186, 63, 217, 1),
          ),
        ),
      ),
      floatingActionButtonLocation: width < 600
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }
}
