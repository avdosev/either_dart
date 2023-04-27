## [0.4.0] - Update Future[Either].fold and Add Either.tryExcept 

Provide more async flexible type support for FutureEither's fold operation. 
> Thanks to @lukasbalaz for creating the [issue](https://github.com/avdosev/either_dart/issues/6) 


add: 
  * tryExcept -
  A simple but powerful constructor for exception handling. Just specify the type of error you expect from the function and you will get `Either<ExpectedError, RightType>`



## [0.3.0] - Add equality and hash override

Either now overrides equality and hash. 
> Thanks to @memishood for creating the [issue](https://github.com/avdosev/either_dart/issues/5) 

## [0.2.0] - Update Future[Either]

Updated to support `FutureOr<T>` instead of `Future<T>`:
  * Either: 
    * thenAsync
    * thenLeftAsync
    * mapAsync
    * mapLeftAsync
  * Future[Either]:
    * thenRight
    * thenLeft

Updated to support `FutureOr<T>` instead of `T`:
  * Future[Either]:
    * mapRight
    * mapLeft


Mark deprecated (not delete):
 * Future[Either].thenRightSync
 * Future[Either].thenLeftSync
 * Future[Either].mapRightAsync
 * Future[Either].mapLeftAsync

The following methods were not needed after `FutureOr` support, so they are marked Deprecated.

## [0.1.4] - Update docs

Update: 
* Readme

(just this)

## [0.1.3] - Additional functionality

Added:
* thenLeft
* thenLeftAsync
* similiar methods for `FutureEither<L, R>` extension

## [0.1.2] - Fixs

Fixed: 
* remove the lint warning from Either.tryCatch


## [0.1.0-nullsafety.2] - Additional functionality and fixes

Added:
* mapLeftAsync
* `FutureEither<L, R>` extension

Fixed:
* change the naming of the async methods of `Either` class

Changes `Either`:
* asyncThen -> thenAsync
* asyncMap -> mapAsync

## [0.1.0-nullsafety.1] - Additional functionality

Added:
* mapLeft

Fixed:
* documentation

## [0.1.0-nullsafety.0] - Additional functionality

Added:
* null-safety
* swap method
* const constructor for Left and Right

Changed:
* rename unite to fold

## [0.0.5] - Additional functionality

Added:
* asyncMap
* asyncThen

## [0.0.4] - Bug fixs

Fixed:
* Not convenient use with autocomplete

## [0.0.3] - Additional functionality and testing

Added:
* Unit test
* Lazy condition
* Flutter example

## [0.0.2] - Additional functionality and testing

Added:

* Unit test
* creators by:
  * condition
  * exception

Fixed:

* pubspec
* Readme

## [0.0.1] - The base implementation either.
Added:

* Base implementation
* Unit test
* Example with flutter
