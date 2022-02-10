# Modular design

This is a sample code used in a dev session to showcase how easily we can achieve a modular design by using the correct design pattern for the task.

## Requirements

Xcode 13 or later is required to open and build this project.

## Approach

For this task we assume that we've been assigned the task of writing the code for the `Load orders` use case, in which we've been given a single requirement at a specific point in time.
Each commit contains a sample code for what is most commonly seen as an implementation, and, a sample of a more composable design.


The first commit contains the project setup and the code needed to fulfil the following requirement: `Fetch orders from a remote endpoint`
The second commit contains the code needed to fulfil the following requirement: `Cache successful responses`
The third commit contains the code needed to fulfil the following requirement: `Load orders from the cache first, fallback to remote`
The forth commit contains the code needed to fulfil the following requirement: `Load orders from the remote first, fallback to cache data`


A fift requirement has been left for the user to practice with the patterns presented in this sample code: `Throttle network requests to only make requests after 1 minute has passed since the last successful request`

## Testing

No tests have been added to the project and it was left for the reader to try and write tests for each of the approaches to verify how much easier/harder one approach would be in comparison to the other.
