# TwitterClient

Restful client for Twitter with Twitter Oauth REST API.

Time spent: 35 hours spent in total

## Completed user stories:

 * [x] Required: User can sign in using OAuth login flow
 * [x] Required: User can view last 20 tweets from their home timeline
 * [x] Required: The current signed in user will be persisted across restarts
 * [x] Required: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 * [x] Required: User can pull to refresh
 * [x] Required: User can compose a new tweet by tapping on a compose button.
 * [x] Required: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 * [x] Required: Hamburger menu - Dragging anywhere in the view should reveal the menu.
 * [x] Required: Hamburger menu - The menu should include links to your profile, the home timeline, and the mentions view.
 * [x] Required: Hamburger menu - The menu can look similar to the menu below or feel free to take liberty with the UI.
 * [x] Required: Profile page - Contains the user header view (implemented as a custom view)
 * [x] Required: Profile page - Contains a section with the users basic stats: # tweets, # following, # followers
 * [x] Required: Home Timeline - Tapping on a user image should bring up that user's profile page
 * [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 * [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
 * [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. 
 * [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 * [ ] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
 * [ ] Optional: Pulling down the profile page should blur and resize the header image.
 * [ ] Optional: Account switching - Long press on tab bar to bring up Account view with animation
 * [ ] Optional: Account switching - Tap account to switch to
 * [ ] Optional: Account switching - Include a plus button to add an Account
 * [ ] Optional: Account switching - Swipe to delete an account


## Installation:

Initial setting up the project now.

```
pod install
open TwitterClient.xcworkspace
```


Here's a walkthrough of implemented user stories:

<img src='https://github.com/almandsky/TwitterClient/raw/master/demo/twitter.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

 * To be provided.

## License

Copyright 2016 Sky Chen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.