import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../model/exchange_request.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../../widget/future_builder/custom_future_builder.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';
import '../../widget/ticket/request_ticket_widget.dart';

class ScreenExchangesTab extends StatelessWidget {
  const ScreenExchangesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedFilters = [Strs.supplierReqStr.tr, Strs.changerReqStr.tr].obs;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => ChipsChoice<String>.multiple(
              scrollPhysics: const BouncingScrollPhysics(),
              // ignore: invalid_use_of_protected_member
              value: selectedFilters.value,
              onChanged: (val) {
                selectedFilters.value = val;
              },
              spinnerBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              textDirection: TextDirection.rtl,
              choiceActiveStyle: C2ChoiceStyle(
                color: Get.theme.colorScheme.secondary,
                showCheckmark: true,
              ),
              choiceItems: C2Choice.listFrom<String, String>(
                source: [Strs.supplierReqStr.tr, Strs.changerReqStr.tr],
                value: (i, v) => v,
                label: (i, v) => v,
              ),
            ),
          ),
        ),
        Expanded(
          child: CustomFutureBuilder(
            future: Future.sync(() async {
              final requests = await ServerService.getExRequestsFromServer(
                  username: ServerService.currentUser.username!);
              return requests.map((e) => ExchangeRequest.fromParse(e)).toList();
            }),
            builder: (context, data) {
              return Obx(
                () {
                  final tickets = DataUtils.filterReqTickets(
                      data as List<ExchangeRequest>, selectedFilters.value);
                  return ClipRRect(
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RequestTicketsView(requests: tickets),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class RequestTicketsView extends StatelessWidget {
  const RequestTicketsView({
    super.key,
    required this.requests,
  });

  final List<ExchangeRequest> requests;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: UniqueKey(),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        addAutomaticKeepAlives: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RequestTicketWidget(
                    request: requests[index],
                    isShowButton: requests[index].supplierUsername ==
                            ServerService.currentUser.username &&
                        requests[index].status == ExchangeRequestStatus.WS,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
