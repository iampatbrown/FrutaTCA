import Foundation

// https://developer.apple.com/forums/thread/664295

private class CurrentBundleFinder {}

public let bundle: Bundle = {
  let currentResourceURL = Bundle(for: CurrentBundleFinder.self).resourceURL
  guard let bundle = [
    /* Bundle should be present here when the package is linked into an App. */
    Bundle.main.resourceURL,
    /* Bundle should be present here when the package is linked into a framework. */
    currentResourceURL,
    /* For command-line tools. */
    Bundle.main.bundleURL,
    /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
    currentResourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
    currentResourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
    currentResourceURL?.deletingLastPathComponent(),
  ]
  .compactMap({ $0?.appendingPathComponent("fruta-tca_IngredientCore.bundle") })
  .compactMap(Bundle.init)
  .first else { fatalError("unable to find bundle") }
  return bundle
}()
