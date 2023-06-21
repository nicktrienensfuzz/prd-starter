// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import Logging
import Dependencies
import Hummingbird
import HummingbirdFoundation
import HummingbirdAuth
import HummingbirdLambda
import AWSLambdaEvents
import AWSLambdaRuntimeCore

@main
struct MyHandler: HBLambda {
    // define input and output
    typealias Event = APIGatewayRequest
    typealias Output = APIGatewayResponse
    
    init(_ app: HBApplication) {
        
//@main
//struct PRDStarter: AsyncParsableCommand {
//    @Option(name: .shortAndLong)
//    var hostname: String = "127.0.0.1"
//
//    @Option(name: .shortAndLong)
//    var port: Int = 8070
//
//    mutating func run() async throws {
//        print("Hello, world!")
//        let app = HBApplication(configuration: .init(address: .hostname(hostname, port: port)))
        
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.decoder = JSONDecoder()
//
//        struct BasicAuthenticator: HBAuthenticator {
//            func authenticate(request: HBRequest) -> EventLoopFuture<User?> {
//                // Basic authentication info in the "Authorization" header, is accessible
//                // via request.auth.basic
//                guard let basic = request.auth.basic else { return request.success(nil) }
//
//                // check if user exists in the database and then verify the entered password
//                // against the one stored in the database. If it is correct then login in user
//                return database.getUserWithUsername(basic.username).map { user -> User? in
//                    // did we find a user
//                    guard let user = user else { return nil }
//                    // verify password against password hash stored in database. If valid
//                    // return the user. HummingbirdAuth provides an implementation of Bcrypt
//                    if Bcrypt.verify(basic.password, hash: user.passwordHash) {
//                        return user
//                    }
//                    return nil
//                }
//                // hop back to request eventloop
//                .hop(to: request.eventLoop)
//            }
//        }
        
        app.router
            .post("/submission") { request -> HBResponse in
            guard let foo = try? request.decode(as: FormData.self) else {
                throw HBHTTPError(.badRequest, message: "Invalid request body.")
            }
            print(foo)
            return try HBResponse(status: .ok,
                                  headers: .init([("contentType", "application/json")]),
                                  body: .data( foo.toString()))
        }
        
        
        app.router.get("form") { request -> HBResponse in
            return HBResponse(status: .ok, headers: .init([("contentType", "application/html")]), body: .data("""
<!doctype html>
<html lang="en">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-aFq/bzH65dt+w6FI2ooMVUpc+21e0SRygnTpmBvdBgSdnuTN7QbdgL+OapgHtvPp" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css" rel="stylesheet">

  <title>Software Feature Requirement Form</title>
</head>

<body>
  <div class="container">
    <div class="row mt-5">
      <div class="col-md-8 offset-md-2">
        <h3 class="text-center">Software Feature Requirement Form</h3>
        <form id="featureForm" >
  
          <div class="mb-5">
            <label for="title" class="form-label ">Feature Title*</label>
            <input type="text" class="form-control control" id="title"
                    placeholder="Enter feature title" required>
          </div>
          <div class="mb-5">
            <label for="description" class="form-label">Feature Overview*</label>
            <textarea class="form-control control" id="description" rows="3"
                    placeholder="Enter feature description" required></textarea>
          </div>
          <div class="mb-5">
            <label for="acceptanceCriteria" class="form-label">Acceptance Criteria*</label>
            <textarea class="form-control control" id="acceptanceCriteria" rows="6"
                    placeholder="Enter acceptance criteria" required></textarea>
          </div>
         <div class="mb-5 well">

         <p>Domain of Feature(best guess)</p>
         <div class="form-check">
           <input class="form-check-input control" type="checkbox" value="1" id="menu">
           <label class="form-check-label" for="menu">Menu</label>
         </div>
         <div class="form-check">
           <input class="form-check-input control" type="checkbox" value="1" id="kiosk">
           <label class="form-check-label" for="kiosk">Kiosk</label>
         </div>
         <div class="form-check">
           <input class="form-check-input control" type="checkbox" value="1" id="kds">
           <label class="form-check-label" for="kds">KDS</label>
         </div>
         <div class="form-check">
           <input class="form-check-input control" type="checkbox" value="1" id="analytics">
           <label class="form-check-label" for="analytics">Analytics</label>
         </div>
       </div>

        <div class="mb-3">
            <label for="date" class="form-label control">Select Ideal Release Date</label>
            <input type="text" class="form-control" id="datepicker" placeholder="Choose date">
        </div>

          <div class="mb-5">
            <button type="submit" class="btn btn-primary">Submit</button>
          </div>
        </form>
      </div>
    </div>
  </div>


<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js" integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

</body>

<script>

$(document).ready(function() {
        $('#datepicker').datepicker({
            calendarWeeks: true,
            autoclose: true
        });
});

 $('#featureForm').on('submit', function(event) {
      event.preventDefault(); // prevent the form from submitting normally

      var formArray = $('#featureForm').serializeArray();
      var formJson = {};
     
        console.log(formArray);

      $.each(formArray, function(i, item) {
        formJson[item.name] = item.value;
      });
    formJson["hi"] = "test";
        
    $(".control").each ( function(i, e) {
        console.log($(e))
        console.log($(e).attr("id"))
        formJson[ $(e).attr("id") ] = $(e).val()
    });

      $.ajax({
        type: 'POST',
        url: '/submission', // replace with your actual submission URL
        data: JSON.stringify(formJson),
        contentType: 'application/json',
        success: function(response) {
          // handle success
          console.log(response);
        },
        error: function(error) {
          // handle error
          console.log(error);
        }
      });
    });
</script>

</html>
"""))
        }
        
//        try app.start()
//        app.wait()
//        
    }
}


extension HBResponseBody {
    static func data(_ data: Data) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes(data)
        return HBResponseBody.byteBuffer(byteBuffer)
        
    }
    static func data(_ string: String) -> HBResponseBody {
        var byteBuffer = ByteBuffer()
        byteBuffer.writeBytes( string.data(using: .utf8)!)
        return  HBResponseBody.byteBuffer(byteBuffer)
    }
}
