#import "DatePickerTimelinePlugin.h"
#if __has_include(<date_picker_timeline_plugin/date_picker_timeline_plugin-Swift.h>)
#import <date_picker_timeline_plugin/date_picker_timeline_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "date_picker_timeline_plugin-Swift.h"
#endif

@implementation DatePickerTimelinePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDatePickerTimelinePlugin registerWithRegistrar:registrar];
}
@end
