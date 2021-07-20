# MovieApp-iOS

Four Third Party Libraries were used and here are the Reasons

1. SDWebImage ~> This was used to load image faster and makes scrolling smother on the collection view. Url Session wasnt used to load images to UIImageview due to the fact that the end point loads alot of image at once, and seting up url session on UIImage view slows down the scrolling of the collection view. This is because when trying to load the image on the main thread after download has been down and adding to the fact that cells are recreated on scrolling of collection view makes it quiet difficult to achieve this using url sesion and Dispatch queue 


2. SwiftyJSON ~> This was used to help decode some error messages from the api and using those error messages to build a custom Error enum that conforms to the Error Protocol and displayed to user


3. FloatRatingView ~> Used to show ratings of movies by Stars. Used to increase good user experience 


4. SnackBar ~> A custom SnackBar for also goo user Experience to tell when a movie has be liked or unlike 
