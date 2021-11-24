## Deliverables

### Decisions/shortcuts
#### Transition using one view or multiple views?

I chose to load the images using the `https://picsum.photos/200/300` URL and had no reference to an id of the random image so I couldn't spin up another webview to show the same image. Hence I chose to re-layout the same view during the transition from the smaller tile to the bigger tile.

A more flexible approach would be to use the `https://picsum.photos/seed/picsum/{width}/{height}` URL and to generate the random seeds in the app. That way you can easily spin up another view or view controller of the same image for other presentation options.

If I would have had more time and if I would have been allowed to use the other API I would have chosen the more flexible approach.

#### UIStacks vs UICollectionView

I chose to use UIStacks to lay out the images in the grid because I was limited in time and there was no mention in the spec of scrolling or loading more images.

If I would have had more time I would have put the images inside a CollectionView.

### XCFramework

[Download](https://github.com/Dev1an/TheoPictures/releases/tag/v0.0.1)