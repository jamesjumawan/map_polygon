import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    Uri uri = Uri.parse(ModalRoute.of(context)?.settings.name ?? '');
    String boundaryName = uri.queryParameters['id'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    mapType: viewModel.mapType,
                    initialCameraPosition: viewModel
                        .getInitialCameraPositionByBoundaryName(boundaryName),
                    onMapCreated: (GoogleMapController controller) {
                      viewModel.controller.complete(controller);
                    },
                    polygons: viewModel.getPolygonByName(boundaryName),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    width: 200,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              viewModel.changeMapType(MapType.terrain),
                          child: Text('Default'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              viewModel.changeMapType(MapType.satellite),
                          child: Text('Satellite'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
