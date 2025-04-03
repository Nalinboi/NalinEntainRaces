# NalinEntainRaces

Hey! This was a fun lil project given by Entain. I've tried my best to fill as much of the project requirements as possible in the time given. 
Here I will discuss what I built, what challenges there were, and what I would do in the future.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Challenges and Decisions](#challenges-and-decisions)
- [Testing](#testing)
- [Future Improvements](#future-improvements)
- [Installation](#installation)

## Project Overview

This is an iOS app made for Entain to showcase my skills. This app shows 5 races at a time, and has a countdown timer for each race. Races have categories that can be filtered with the picker.

The app fetches an API given by Entain for the race information to be displayed. I utilise an MVVM archetecture and use dependency injections for NetworkManagers to be injected (real or mock).
Unit and UITests have also been implemented.
The app was made in SwiftUI with Swift 6.

Here's a quick demo!

*Note*: The app automatically fetches and refreshes the UI every 60 seconds. In the demo I mention that this was not completed which is no longer true.

https://github.com/user-attachments/assets/1d0b96f2-da02-4ca1-8802-b23b3ce0426d

## Features

- **Race List**: Displays a list of upcoming races, each with its race number, category, and a countdown to the race start.
- **Race Category Filter**: A dropdown picker allows users to filter races by category (e.g., horse racing, greyhound racing, harness racing).
- **Countdown Timer**: Each race has a countdown timer that updates every second.
- **NetworkManager and MockNetworkManager for Testing**: Mock data is used for testing and UI previews to simulate network responses.

Here is a breakdown of what I was able to achieve
* As a user, I should be able to see a time-ordered list of races ordered by advertised start ascending. ✅
* As a user, I should not see races that are one minute past the advertised start. ✅
* As a user, I should be able to filter my list of races by the following categories: ✅
    * Horse, ✅
    * Harness &amp; ✅
    * Greyhound racing.✅
* As a user, I can deselect all filters to show the next 5 of all racing categories. ✅ (partially)
* As a user, I should see the ✅
    * meeting name, ✅
    * race number and ✅
    * advertised start as a countdown for each race.✅
* As a user, I should always see 5 races and data should automatically refresh. ✅ (partially true, the data automatically refreshes every minute, however I do not implement paging. So if you filter, there may be 5 races shown.

## Challenges and Decisions

- **Handling Network Calls**: I had made a NetworkManager with a singleton that could be called from any class. I used it through a dependency injection in RacesViewModel to make the get request and get the data I needed for the view.

- **Handling UI Changes**: I had made my viewModel @MainActor so most changes (as most changes in the viewModel are for the UI) are done on the main thread. However some tasks such as the async api fetching are executed on the background thread.
  
- **State Management**: Using `@Published` properties to immediately reflect data changes in the view

- **UI/UX Decisions**: I chose a simple and clean interface with a focus on functionality. If I had more time I would definitely make this look a lot more pretty. Countdowns are green, when a races has started however the timer will go red.

## Testing

I’ve written **unit tests** and **UI tests** to ensure that the app functions as expected.
Unfortunately I didn't have enough time to flesh out my MockNetworkManager which is used for all the testing. 
I wanted to give in dynamic jsons so that I could change the advertised_start to a time after the present.

If this could have been done I would have had far more UITests.

## Future Improvements

1. **Pagination**: Currently the races can be refreshed and also happens every minute. I wasn't sure if we wanted to keep adding more to the count for the GET request if lets say you filtered for Horse races, and the 30 races you pulled still only had Horse races. Could lead to infinite paging if an expected category never pulls through. 
   
3. **Multiple filter options**: Pickers are intended to be used in a way that you only pick one, but I would have liked the feature for multiple filters
   
4. **Styling**: The UI can take some time to load so a loading screen would be nice, the refresh spinner could sit there for longer, I wanted to add assets or images, colours etc. 
   
5. **MockNetworkManger**: Allow for dynamic variables in local jsons to edit the advertised_time.


## Installation

To run this project locally, follow these steps:

1. Clone this repository:

    ```bash
    git clone https://github.com/Nalinboi/NalinEntainRaces.git
    ```

2. Open the project in Xcode:

    ```bash
    open NalinEntainRaces.xcodeproj
    ```

**Note:** If you have any questions, feel free to reach out to me at nalinaswani@gmail.com
