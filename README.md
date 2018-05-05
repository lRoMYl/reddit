# reddit

A simplified Reddit app to demo using MVVM without RX library and Repository design pattern

# Functionalities;
- List of topics, sorted by vote and filtered to 20 items (In-memory repo, no persistency)
Topics are stored into TopicRepository that implements a custom generic Repository protocol that adhere to simple operation such as find, getAll, add, update and delete
Sorting is implemented using Comparable interface and built-in sort mechanism, specifically sorted(by:)
Filtering is implemted using built-in filter mechanism, specifically prefix(_:)

- Add text based topic with minimum 0 characters and maximum 255 characters limit validation
Simple validation using guard statement to check for the inputs validity after removing white space and new lines
Custom error enum and implemented LocalizedError interface to support custom error message based on the error enum
A simple error alert using the custom error

- Upvote/Downvote
Upvote and downvote action will update the repository data and the list will be refresh in real time to reflect the latest vote count
The list of topics will always reoder when new topic are added but not for upvote/downvote action as it would make it very hard to repetitively press the upvote/downvote button when the view keep moving around by itself
A pull to refresh mechanism is provided to fetch the latest topics according to the sort and filter strategy

- ViewModel and Repository test cases, including dependency injection to swap the repository
All ViewModel and Repository is tested individually in test cases
The ViewModel also allow dependency injection of the repository to perform the testing in isolation

- MVVM view binding
The ViewModel value will automatically trigger the listener to update the view accordingly in setupListener without the usual RxSwift/ReactiveSwift library using Box concept which accept a generic Value and then trigger the listener when the value or listener is set
