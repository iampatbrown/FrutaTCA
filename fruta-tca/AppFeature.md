#  AppFeature

## Questions

- Should all views have explicit ViewState/ViewAction? More in terms of style. I like the idea of reinforcing the
 difference between GlobalState and ViewState but am unsure if it overkill. 
- Also should ViewState/ViewAction initializers be located after the View?
- How to store navigationState? tabNav vs sideBar nav
- When to use WithViewStore vs @ObservedObject? ie. should always start with WithViewStore? then only use 
@ObservedObject with more complex views or when required?
- Additional Features? Fruta lacks things like persistence and actually ordering of smoothies. Should this be added? 
If so, how do we ensure they are isolated/don't distract from the existing Features/Models.
- Scheme management: Is it okay to just remove the auto-created composable-architecture schemes?

## TODO

[] ViewState and ViewAction

## Notes



### Sharing state between features

Following [this example.](https://forums.swift.org/t/how-to-share-states-between-different-levels-of-nested-states/37095/2)
Wouldn't mind demonstrating multiple ways to achieve this with pros/cons

## View Structure

- AppView - TabNavigation
    - MenuFeature
    - FavoritesFeature
    - RewardsFeature
    - RecipesFeature
- AppView - SidebarNavigation
    - MenuFeature
    - FavoritesFeature
    - RecipesFeature
    - Sheet: RewardsFeature
