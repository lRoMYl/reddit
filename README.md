# reddit

A simplified Reddit app to demo using MVVM without RX library and Repository design pattern

## Functionalities
### List of topics, sorted by vote and filtered to 20 items (In-memory repo, no persistency)
- A struct Topic is used to store the data for the topic
- A common Repository protocol which includes all basic operation such as find, getAll, add, update and delete
- TopicRepository implement the Repository protocol and manage an array of Topic struct internally, all operations are done using the internal array of Topic.
- Sorting is implemented using Comparable interface and built-in sort mechanism, specifically sorted(by:)
- Filtering is implemented using built-in filter mechanism, specifically prefix(_:)
- A standalone DataSource that separates the implementation of UITableViewDataSource, UITableViewCell registration and data management from the view controller

### Add text based topic with minimum 0 characters and maximum 255 characters limit validation
- Simple validation using guard statement to check for the inputs validity after removing white space and new lines
- Custom error enum and implemented LocalizedError interface to support custom error message based on the error enum
- A simple error alert using the custom error

### Upvote/Downvote
- Upvote and downvote action will update the repository data and the list will be refresh in real time to reflect the latest vote count
- The list of topics will always reoder when new topic are added but not for upvote/downvote action as it would make it very hard to repetitively press the upvote/downvote button when the view keep moving around by itself
- A pull to refresh mechanism is provided to fetch the latest topics according to the sort and filter strategy

### ViewModel and Repository test cases, including dependency injection to swap the repository
- All ViewModel and Repository is tested individually in test cases
- The ViewModel also allow dependency injection of the repository to perform the testing in isolation

### MVVM view binding
- Boxing implemention, a Box class that is initialize using a generic associatedType value
- Box include a bind method that accept a closure parameter, which can be used to update the desired UI element when changes occur to the value
- ViewModel is implemented using three procotols, typically ViewModelOutputs, ViewModelInputs, and lastly ViewModelType which combine ViewModelOutputs and ViewModelInputs and expose it as a inputs and outputs variable. 
- By Using the ViewModelType, there is a clear differentiation when accessing the viewModel properties. E.g. viewModel.inputs.didTapAdd() which represent input from the ViewController and viewModel.outputs.title which represent value that will changed and can be subscribed to update the view using the closure.
