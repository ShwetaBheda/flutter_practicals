import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practical/blocs/products/products_bloc.dart';
import 'package:flutter_practical/models/product.dart';
import 'package:flutter_practical/repositories/product_repo.dart';
import 'package:flutter_practical/servicdes/dio_service.dart';
import 'package:flutter_practical/widgets/drawer.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductRepository productRepository = ProductRepository(DioService());
    // Wrap DashboardScreen with BlocProvider if not already provided higher up the widget tree
    return BlocProvider<ProductBloc>(
      create: (context) =>
          ProductBloc(productRepository)..add(FetchProductsEvent()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            // Show loading indicator while products are being fetched
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProductLoaded) {
            // Products are successfully loaded
            final products = state.products;

            // Generate data for the charts
            final categoryCounts = ProductHelper.getCategoryCounts(products);
            final maxDiscounts = ProductHelper.getMaxDiscounts(products);
            const selectedCategory = "beauty"; // Example selected category
            final topProducts =
                ProductHelper.getTopProducts(products, selectedCategory);

            return Scaffold(
              appBar: AppBar(title: const Text('Dashboard')),
              drawer: const SharedNavigationDrawer(currentScreen: 'Dashboard'),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Pie Chart Widget
                    PieChartWidget(categoryCounts: categoryCounts),
                    const SizedBox(height: 50),
                    // Max Discount Chart Widget
                    MaxDiscountChart(maxDiscounts: maxDiscounts),
                    const SizedBox(height: 50),
                    // Top Products Table
                    TopProductsTable(topProducts: topProducts),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          } else if (state is ProductError) {
            // Show error message if loading fails
            return Scaffold(
              body: Center(
                child: Text('Error: ${state.message}'),
              ),
            );
          }

          // Default state (fallback)
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const PieChartWidget({super.key, required this.categoryCounts});

  @override
  Widget build(BuildContext context) {
    final sections = categoryCounts.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        radius: 70,
        color: getColorForCategory(entry.key),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(sections: sections),
      ),
    );
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'beauty':
        return Colors.pink;
      case 'fragrances':
        return Colors.blue;
      case 'groceries':
        return Colors.green;
      case 'furniture':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}

class MaxDiscountChart extends StatelessWidget {
  final Map<String, double> maxDiscounts;

  const MaxDiscountChart({super.key, required this.maxDiscounts});

  @override
  Widget build(BuildContext context) {
    // Safeguard: Ensure there are no empty keys or invalid data
    final validDiscounts = maxDiscounts.entries
        .where((entry) => entry.key.isNotEmpty && entry.value > 0)
        .toList();

    // Prepare bar groups
    final barGroups = validDiscounts.asMap().entries.map((entry) {
      final index = entry.key;
      final discount = entry.value.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: discount,
            color: Colors.orange,
            width: 15, // Increased width for better visibility
            borderRadius: BorderRadius.circular(5),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(15),
      height: 350, // Increased height for better visual appeal
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < validDiscounts.length) {
                    return Text(
                      validDiscounts[value.toInt()].key,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3), // Lighter grid lines
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3), // Lighter grid lines
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          alignment: BarChartAlignment.spaceBetween,
        ),
      ),
    );
  }
}

class TopProductsTable extends StatelessWidget {
  final List<Product> topProducts;

  const TopProductsTable({Key? key, required this.topProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Image')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Warranty')),
      ],
      rows: topProducts.map((product) {
        final actualPrice = product.price;
        final discountedPrice =
            actualPrice * (1 - (product.discountPercentage ?? 0) / 100);
        return DataRow(cells: [
          DataCell(
            Stack(
              children: [
                Image.network(product.thumbnail ?? "default_image_url",
                    width: 50, height: 50),
                if (product.availabilityStatus == 'Out of Stock')
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          DataCell(Text(product.title)),
          DataCell(Text(
              '\$${actualPrice.toStringAsFixed(2)} (\$${discountedPrice.toStringAsFixed(2)} with discount)')),
          DataCell(Text(product.warrantyInformation ?? "No warranty")),
        ]);
      }).toList(),
    );
  }
}

class ProductHelper {
  static Map<String, int> getCategoryCounts(List<Product> products) {
    return products.fold({}, (counts, product) {
      counts[product.category] = (counts[product.category] ?? 0) + 1;
      return counts;
    });
  }

  static Map<String, double> getMaxDiscounts(List<Product> products) {
    final Map<String, double> maxDiscounts = {};

    for (var product in products) {
      // Ensure category is not null or empty
      if (product.category.isNotEmpty) {
        // Update the max discount for the category
        maxDiscounts[product.category] =
            maxDiscounts.containsKey(product.category)
                ? product.discountPercentage! > maxDiscounts[product.category]!
                    ? product.discountPercentage!
                    : maxDiscounts[product.category]!
                : product.discountPercentage!;
      }
    }

    return maxDiscounts;
  }

  static List<Product> getTopProducts(List<Product> products, String category) {
    return products.where((product) => product.category == category).toList()
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0))
      ..take(5).toList();
  }
}
