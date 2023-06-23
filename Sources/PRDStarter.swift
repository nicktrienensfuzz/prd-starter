// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import Logging
import Hummingbird
import HummingbirdCore
import HummingbirdFoundation

import HummingbirdLambda
import AWSLambdaEvents
import AWSLambdaRuntimeCore

@main
struct PRDStarter: HBLambda {
    // define input and output
    typealias Event = APIGatewayRequest
    typealias Output = APIGatewayResponse

    init(_ app: HBApplication) {
        
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.decoder = JSONDecoder()
        
        configure(app)
    }
}

/*
@main
struct PRDStarter: AsyncParsableCommand {
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8070

    mutating func run() async throws {
        print("Hello, world!")
        let app = HBApplication(configuration: .init(address: .hostname(hostname, port: port)))
        
        app.middleware.add(HBLogRequestsMiddleware(.debug))
        app.decoder = JSONDecoder()
        
        configure(app)
        
        try app.start()
        app.wait()
    }
 }
*/


extension PRDStarter {
    
    func configure(_ app: HBApplication) {
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
            return HBResponse(status: .ok, headers: .init([("contentType", "text/plain"),("contentType", "application/html")]), body: .data("""
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
    <div class="row mt-3">
      <div class="col-md-8 offset-md-2">
        <h3 class="text-center">Software Feature Requirement Form</h3>
<xform id="featureForm" >
  
          <div class="mb-5">
            <label for="title" class="form-label ">Feature Title*</label>
            <input type="text" class="form-control control" id="title"
                    placeholder="Enter feature title" required>
          </div>
          <div class="mb-5">
            <label for="description" class="form-label">Feature Overview*</label>
            <textarea class="form-control control" id="description" rows="3"
                    placeholder="Description of what you hope to achieve in this work and any background information that will
help inform the team." required></textarea>
          </div>
          <div class="mb-5">
            <label for="strategicAlignment" class="form-label">Strategic Alignment*</label>
            <textarea class="form-control control" id="strategicAlignment" rows="6"
                    placeholder="Explanation of how this new customer experience supports business and product goals" required></textarea>
          </div>

          <div class="mb-5">
            <label for="successMetrics" class="form-label">Success Metrics*</label>
            <textarea class="form-control control" id="successMetrics" rows="6"
                    placeholder="Explanation of how this new customer experience supports business and product goals" required></textarea>
          </div>


          <div class="mb-5">
            <label for="userStories" class="form-label">User Stories</label>
            <textarea class="form-control control" id="userStories" rows="6"
                    placeholder="List requirements in user story format. Please make sure to have some high level requirements
documented." ></textarea>
          </div>

<div class="mb-5">
  <h3 class="text-center mt-4">User Stories</h3>
  <div class="row justify-content-center mt-4">
      <form id="list-form">
        <div class="form-group input-group">
            <input type="text" class="form-control" id="list-item-input" placeholder="Add User Story" aria-describedby="button-addon2" >
            <button type="button" class="btn btn-primary" id="button-addon2">Add Item</button>
        </div>
      </form>
  </div>

  <div class="row justify-content-center mt-4">
    <ul id="list" class="list-group userStoryList"></ul>
  </div>
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

        <div class="spinner-border mb-5" style="width: 6rem; height: 6rem;" role="status" >
          <span class="visually-hidden">Loading...</span>
        </div>

        <div class="mb-5">
            <button type="submit" class="btn btn-primary featureButton">Submit</button>
            <button type="button" class="btn btn-outline-danger featureButtonReset">Reset</button>
        </div>


<div class="mb-5" > </div>

        </xform>
      </div>
    </div>
  </div>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js" integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>


<div class="toast position-fixed bottom-0 end-0 p-3 m-5" role="alert" aria-live="assertive" aria-atomic="true">
  <div class="toast-header">
    <strong class="me-auto">Saved!!</strong>
    <small class="text-muted">now</small>
    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
  </div>
  <div class="toast-body">
        PRD created <span class="prdtitle" ></span> <br/>
        <span class="prdlink" ></span>
  </div>
</div>

</body>

<script>

$(document).ready(function() {
        $('#datepicker').datepicker({
            calendarWeeks: true,
            autoclose: true
        });

    $(".spinner-border").hide()
    $(".toast").hide()

    $('#list-form').on('submit', function(e) {
      e.preventDefault();

      const listItem = $('#list-item-input').val().trim();

      if (listItem) {

      $('#list').append(`
        <li class="list-group-item d-flex justify-content-between align-items-center">
          <span class="userStoryListItem" >${listItem}</span>
          <button class="btn btn-outline-danger btn-sm list-group-item-delete">
            <i class="bi-trash"></i>
          </button>
        </li>
      `);
        $('#list-item-input').val('');
      }
    });

    $('#list').on('click', '.list-group-item-delete', function() {
      $(this).parent().remove();
    });
});

$('.featureButtonReset').on('click', function(event) {
    $(".control").each ( function(i, e) {
        $(e).val('');
    });
});

$('.featureButton').on('click', function(event) {
      event.preventDefault(); // prevent the form from submitting normally

      var formArray = $('#featureForm').serializeArray();
      var formJson = {};
     

      $.each(formArray, function(i, item) {
        formJson[item.name] = item.value;
      });
        
    $(".control").each ( function(i, e) {
//        console.log($(e))
//        console.log($(e).attr("id"))
        formJson[ $(e).attr("id") ] = $(e).val()
    });

    formJson[ "userStoryList" ] = ""
    $(".userStoryListItem").each ( function(i, e) {
        formJson[ "userStoryList" ] += $(e).text() + "\\n"
    });

        console.log("Starting load");

      $(".spinner-border").show()
      $.ajax({
        type: 'POST',
        url: 'submission', // replace with your actual submission URL
        data: JSON.stringify(formJson),
        contentType: 'application/json',
        success: function(response) {
            // handle success
            console.log(response);
            $(".spinner-border").hide()
            $(".prdtitle").text("response.data.title")
            $(".prdlink").html('<a href="cnn.com">cnn.com</a>')
            $(".toast").show()
        },
        error: function(error) {
          // handle error
          console.log(error);
          $(".spinner-border").hide()
        }
      });
    });
</script>

</html>
"""))
        }

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
