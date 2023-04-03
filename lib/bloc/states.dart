abstract class AppStates{}
class InitState                    extends AppStates{}
class FillSamplesListState         extends AppStates{}
class FillSearchedSamplesListState extends AppStates{}
class AddSampleState               extends AppStates{}
class GetSampleState               extends AppStates{}
class UpdateSampleState            extends AppStates{}
class SendSampleState              extends AppStates{}
class FinishSampleState            extends AppStates{}
class DeleteSampleState            extends AppStates{}
class ChangeDeletingState          extends AppStates{}
class ChangeRequestPathState       extends AppStates{}
class ChangeResultPathState        extends AppStates{}
class ChangeWidthState             extends AppStates{}
class ChangeHeightState            extends AppStates{}
class ConnectionCheckerState       extends AppStates{}