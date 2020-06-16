# Venue Tracker App

**Venue Tracker iOS App** consists of one screen: Venue List, in addition of splash screen.

On the Venue List screen, user is able to see 15 nearby Venue locations (venues).
The list keeps getting updated every 10 seconds.

On the same screen, user can favorite / unfovorite Venue venues.

## App Architecture Overview:

Venue Tracker relies on 6 protocols for its business logic handling: **LocationProvider, Fetcher, Presenter, Presenting, Updater, Updating**.

- **LocationProvider**:  Classes conforming to this protocol provide (live/random) location coordinates whenever requested. 
Currently, `FakeLocationProvider` emits random locations around Kamppi, Helsinki.

- **Fetcher**: Classes conforming to this protocol are responsible for fetching data from REST API (usually GET requests) at regular intervals as prescribed by `timeInterval` property.
In Venue Tracker, currently `VenueFetcher` fetches venues from TripAdvisor API (https://tripadvisor1.p.rapidapi.com/) every 10 seconds. 

`Fetcher` also holds `shouldNavigateBlock` optional block that can be invoked to signal the caller about possible need for navigation. `shouldNavigateBlock` can also be injected into other protocols as per the requirement.

- **Presenter**: Classes that implement `Presenter` hold data items for their `Presenting`(see below) View Controllers. `dataItems` is an array of business layer objects that are, when set, updates the UI of `Presenting` view controllers. Currently, `VenuePresenter` holds `dataItems` of type `Venue` object array.

- **Presenting**: Classes that implement `Presenting` deal with UI, i.e. views and view controllers. They must implement `updateUIWithDataItems` and `showErrorMessage` to perform UI update.
Currently, `VenueListViewController`is the only class that implements `Presenting`.

- **Updater**: Classes that implement `Updater` initiates saving of mutated data to data storage. They must implement `updateData` and `postDataToAPI`. Generic implementation of `ùpdateData` simply calls `updateDataModel`of every `Updating` object.

- **Updating**: Business layer objects (presently, `Venue`) implement this protocol. They must implement `updateDataModel`, which converts their in-memory properties into `NSManagedObjectModel` via core data context saving operation.

**A Note about Navigator Class**:

This class will have helpers to create view controllers from storyboard on the fly, and handle navigation.
The basic purpose of this class is to maintain strong reference to all fetchers and presenters.
App delegate will have reference to a Navigator object so it can be accessed by any view controller.

This could be extended to keep track of every nav controller in the app for easy push-pop-present operation.
When application grows too complex having many view controllers, additional Navigators could be created to keep track of various application flows.

### Data Handling:

Data handling is done through business level object (`Venue`, in the present scope) and Core Data models (`VenueModel`)

`Venue` object can be instantiated either from JSON (REST response from `/venues` API) or `VenueModel` via `venueFromModel`function.

`VenueModel` is a core data class generated from data model inside `VenueTrackerModel.xcdatamodeld`- `VenueModel`entity. It has functions for queries, insertion and update based on Core Data API. Among other things, it stores `isFavorite` flag which is responsible for remembering user's venue favoriting choice.

`CoreDataManager.swift` is a generic initializer for Core Data related stuff. All properties are lazily initialized. It manages 2 managed object contexts: `queryContext` (used for `SELECT`) and `mutationContext` (used for `INSERT` and `UPDATE`)

### Networking:

`NetworkManager.swift` holds all functions to handle network activity. It maintains a strong reference to `URLSession` object. `fetchFromRest` function invokes network call, and is consumed by all `Fetcher` implementors.

### UI:

Upon every venue update, table view is refreshed with shuffling of rows. A simplistic `moveRow` based operation with animation is implemented in `VenueListViewController`.

`VenueListCell.xib` (and `VenueListCell.swift`) is responsible for displaying data in `Venue List View Controller`. 

`VenueListCell` contains, among other things, `venueThumbnail`, whose image is set using `thumbnailURL` property. 

Upon tapping favorite button, **pulse**() (`UIView.pulse()`) animation is triggered to favorite/unfavorite a Venue venue.

A special implementation of `NSCache` - `URLCache` will ensure venue thumbnails gets loaded from their URL, saved on disk(upto 30 MB, then flushed), and also cached in memory (upto 10 MB)

## Unit Tests:

`VenueTrackerTests`target contains tests about data conversion into `Venue` object. This is in progress work.

## UI Tests:

`VenueTrackerUITests` target contains basic UI tests that verify basic stuff like screen appearance, and table view cells..

## Limitations:

- No unit tests for core data operations. Reason being, currently no good mock support exists for Swift. But with some exploration these can be developed and maintained.

- Error logging is quite simplistic, using `print` statement.. With some design, logging could be more structured and categorized (e.g. error, warning, info). 
3rd party solutions could also help improving quality of logs.

- Currently, app does not track live user location using `Core Location`. Location based querying to REST is achieved using location stub `FakeLocationProvider.swift`, which is convenient to work with for development purposes.
`RealLocationProvider.swift`(fully commented out presently) can be utilized to implement the real requirement using Core Location API.