<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A class that can be used to derive a value based on data from another
Listenable or Listenables.

<!-- ## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package. -->

## Usage

 The value will be recomputed when the provided `listenable` notifies the
 listeners that values have changed.

 ### Simple Example

 ```dart
 final email = ValueNotifier<String>('a');

 // Determine whether or not the email is valid using a (hacky) validator.
 final emailValid = ComputedValueNotifier(
   email,
   () => email.value.contains('@'),
 );

 // The function provided to ComputedValueNotifier is immediately executed,
 // and the computed value is available synchronously.
 print(emailValid.value); // prints 'false'.

 // When the email ValueNotifier is changed, the function will be run again!
 email.value = 'a@b.com';
 print(emailValid.value); // prints 'true'.
```
## Additional information
Thanks to [Brian Egan](https://github.com/brianegan) for the [gist](https://gist.github.com/brianegan/ad83f7bc2ce63976145596ab8cb51f7b)

