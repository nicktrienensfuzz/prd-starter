import ArgumentParser
import ConfluenceAPI
import Foundation
import JSON
import PathKit
import Stencil
import JiraClient
import Networker

// ConfluenceReader conforms to AsyncParsableCommand, enabling its usage in async-await pattern
@main
struct ConfluenceReader: AsyncParsableCommand {
    private(set) var text = "Hello, World!"
    
    var projectKey: String = "INDI"

    static func main() async {
        do {
            
            
            //try await ConfluenceReader().getTickets()
//            let jsonObject = json {
//                [
//                    "name": json {
//                        ["name": "John Doe", "test": 4.5]
//                    }
//                ]
//            }
//            print(jsonObject)
//
//            let jsonArray = json {
//                "Hello"
//                ["name": json {
//                    ["name": "John Doe", "test": 4.5]
//                }]
//                ["name":  JSON.array { "test" }]
//                45.6
//                false
//                789.10
//                if Bool.random() {
//                    "Conditional"
//                } else {
//                    "FAIL"
//                }
//            }
//            print (jsonArray)
          
            try await ConfluenceReader().getSummary()
           try await ConfluenceReader().addComments()
            
        } catch {
            print(error)
        }
    }
    
    func getSummary() async throws {
        let token = ProcessInfo.processInfo.environment["JIRA_API_KEY"] ?? ""
        let chatToken = ProcessInfo.processInfo.environment["CHAT_GPT_API_KEY"] ?? ""
        let chatClient = ChatAPI(chatGPTAPIKey: chatToken)

        let dateStarted1 = Date()

        let imagePrompt = "Draw a master engineer Beaver, studio ghibli"
        let testImage = try await chatClient.createImages(with: imagePrompt, numImages: 1, size: ImageSize.size512)
        
        let url = try testImage.data.unwrapped().first.unwrapped()
        let data = try await RequestMaker().makeRequest(Endpoint(method: .GET, path: url.url))
        
        try (Path.current + Path("\(imagePrompt).png")).write(data)
        //try print(testImage.data.unwrapped().first.unwrapped())
        
        let responseStory = try await chatClient.sendRequest(question: "Start a story appropriate for kids age 10, build 3 consistent characters", conversation: .init(messages: [ChatRequestDTO.Message(role: "system", content: "We are writing a choose you own adventure story, after each installment present a list of 2 - 3 options and create a detailed Dall-e prompt to generate each in relation to the content. In a single json array formatted block ```{\"options\": [<option> ], \"characters\": {<characterName>: <Prompt> }```" )] ))
        print("took:", abs(dateStarted1.timeIntervalSinceNow))
        print(responseStory.messages.last?.content ?? "")
        
        let client = ConfluenceAPIClient(configuration: JiraConfiguration(token: token, baseURL: "https://monstarlab.atlassian.net/wiki/rest/api/"))
        let page = try await client.getContent(identifier: "7961084141")
        
        let requirements = try await client.getContent(identifier: "7842791469")
        //print(page.body.view.value)
        
        let dateStarted = Date()
        let response = try await chatClient.sendRequest(question: "create a overview of the work to be done", conversation: .init(messages: [ChatRequestDTO.Message(role: "system", content: page.body.view.value + "----\nRequirements:" + requirements.body.view.value)] ))
        print("took:", abs(dateStarted.timeIntervalSinceNow))
        print(response.messages.last?.content ?? "")
    }
    
    
    func addComments() async throws {
        let token = ProcessInfo.processInfo.environment["JIRA_API_KEY"] ?? ""
        let chatToken = ProcessInfo.processInfo.environment["CHAT_GPT_API_KEY"] ?? ""
        //
        //        let client = ConfluenceAPIClient(configuration: JiraConfiguration(token: token, baseURL: "https://monstarlab.atlassian.net/wiki/rest/api/"))
        //        let page = try await client.getContent(identifier: "7792066679")
        //
        //        let requirements = try await client.getContent(identifier: "7842791469")
        //        //print(page.body.view.value)
        //
        
        let chatClient = ChatAPI(chatGPTAPIKey: chatToken)
        for p in try (Path.current + Path("Sources/ConfluenceReader")).children() {
            let dateStarted = Date()
            print( p.string )
            guard p.string.contains(".swift") else { continue }
            print(p)
            let fileContents: String = try p.read()
            let response = try await chatClient.sendRequest(question: "Add Documentation to this swift file use standard swift comment style\n\n\(fileContents)",
                                                            conversation: .init(messages: []))
            
            print("took:", abs(dateStarted.timeIntervalSinceNow))
            print(response.messages.last?.content ?? "")
        }
        
        
        
        
        //let response = try await chatClient.sendRequest(question: "Add Documentation to this swift ", conversation: .init(messages: [ChatRequestDTO.Message(role: "system", content: page.body.view.value + "----\nRequirements:" + requirements.body.view.value)] ))
        
    }
    
    
    func getTickets() async throws {
        let token = ProcessInfo.processInfo.environment["JIRA_API_KEY"] ?? ""
        let chatToken = ProcessInfo.processInfo.environment["CHAT_GPT_API_KEY"] ?? ""
        
        let client = JiraAPIClient(configuration: JiraConfiguration(token: token))
        
        let tickets = try await client.issues(projectKey: projectKey)
        
        let reduced = tickets.issues.map{ """
        
        
        Key: \($0.key)
        Summary: \($0.fields.summary)
        Description: \($0.fields.description ?? "")
        Epic: \($0.fields.epic ?? "")
        
         
        """
        }
        
        try (Path.current + Path("sampleTickets.txt")).write(reduced.joined())
        
        
        var messages = [ChatRequestDTO.Message]()
        var message: String = ""
        let threshold = 15000
        reduced.forEach { ticket in
            if message.count + ticket.count < threshold {
                message += ticket
            } else {
                messages.append(.init(role: "system", content: message))
                message = ticket
            }
        }
        
        
        let chatClient = ChatAPI(chatGPTAPIKey: chatToken)
//        let responseEM = try await chatClient.createEmbeddings(input: messages.first?.content ?? "")
//        try (Path.current + Path("sampleembeddings.txt")).write(JSONEncoder().encode(responseEM))

        
        print( messages.count )
        let response = try await chatClient.sendRequest(question: "summarize these jira tickets into a FRD", conversation: .init(messages: Array(messages.prefix(100)) ))
        
        try (Path.current + Path("sampleResponse.txt")).write(JSONEncoder().encode(response))
        
    }
}

//    func main() async throws {
//        let test = EndpointChecker()
//        //  let response =  try await test.postAny()
//        //  let json = try JSON(data: response)
//        //  print(json)
//
//        let templateId = "7807631443"
//        let targetId = "7810220050"
//        let templateContent = try await test.fetchPage(identifier: templateId)
//        try (Path.current + Path("\(templateId).html")).write(templateContent.body.view.value)
//
//        struct Outage {
//            let total: String
//            let monitoringInterval: String
//            let disabledInterval: String
//        }
//
//        let context = [
//            "outages": Outage(total: "3", monitoringInterval: "5 Hours", disabledInterval: "3h 37m")
//        ]
//
//        let environment = Environment(loader: FileSystemLoader(paths: [""]))
//        let rendered = try environment.renderTemplate(name: "\(templateId).html", context: context)
//        print("update template")
//        try (Path.current + Path("\(templateId)_final.html")).write(rendered)
//
////         try await test.confluenceAPI.createContent(spaceId: "BLJY",
////                                                    parentPage: 7801372751,
////                                                    title: "Filled test2",
////                                                    body:  (Path.current + Path("\(templateId)_final.html")).read() )
//
//        // try content.body.view.value = (Path.current + Path("7807631443_final.html")).read()
//        let content = try await test.fetchPage(identifier: targetId)
//        try (Path.current + Path("\(targetId)_final.html")).write(content.body.view.value)
//        print("update page content")
//
//        let res = try await test.confluenceAPI.updateContent(
//            identifier: targetId,
//            content: content,
//            body: (Path.current + Path("\(templateId)_final.html")).read()
//        )
//
//        let data = try await test.getPDF(identifier: targetId)
//        print(data.count)
//
////
////         let taskId = try await test.confluenceAPI.getPageAsPDF(identifier: targetId)
////
////         var responseURL: String? = nil
////         var attempts = 0
////         while responseURL == nil {
////             do {
////                 responseURL = try await test.confluenceAPI.pollPDF(task: taskId)
////                 } catch {
////                  print(error)
////                     if attempts > 100 {
////                         throw error
////                     }
////                 }
////             attempts += 1
////         }
////         let data = try await test.confluenceAPI.downloadPDF(file: responseURL.unwrapped())
//    }
//}
//
//class EndpointChecker {
//    internal init() {
////        httpClient = HTTPClient(
////            eventLoopGroupProvider: .createNew,
////            configuration: HTTPClient.Configuration(timeout: HTTPClient.Configuration.Timeout(
////                connect: .seconds(10),
////                read: .seconds(10)
////            ))
////        )
////
//        confluenceAPI = ConfluenceAPIClient(requester: RequestMaker(), configuration: JiraConfiguration())
//    }
//
////    let httpClient: HTTPClient
//    let confluenceAPI: ConfluenceAPIClient
////    deinit {
////        try? httpClient.syncShutdown()
////    }
//
////    func postAny( identifier: String = "7802421336") async throws -> Data {
////        let response = try await httpClient.makeRequest(
////            Endpoint(
////                method: .POST,
////                path: "https://a6zdf5aek5.execute-api.us-west-2.amazonaws.com/dev/object" + "?id=\(identifier)",
////                headers: ["X-API-KEY": "sdDFlfSXltO2cSsGsoLKkvSI5vKffBbt"],
////                body: "{testing:\"234\"}".asData
////            )
////        )
////        return response
////    }
//    func getPDF(identifier: String = "7802421336") async throws -> Data {
//        let response = try await RequestMaker().makeRequest(
//            Endpoint(
//                method: .GET,
//                path: "https://r51ocvu38l.execute-api.us-east-1.amazonaws.com/generate",
//                body: nil
//            )
//        )
//        return response
//    }
//
//    func fetchPage(identifier: String = "7802421336") async throws -> Confluence.Content {
//        try await confluenceAPI.getContent(identifier: identifier)
//    }
//}

public struct JiraConfiguration: JiraConfigurationInterface, ConfigurationInterface {
    internal init(email: String = "", token: String , projectKey: String = "BJKDS", baseURL: String = "https://monstarlab.atlassian.net/rest/") {
        self.email = email
        self.token = token
        self.projectKey = projectKey
        self.baseURL = baseURL
    }
    
    public let email: String
    public let token: String
    public let projectKey: String
    public let baseURL: String
}


// swiftlint:disable force_unwrapping
extension JSON {
    init(_ string: String) throws {
        let d = string.data(using: .utf8)
        self = try JSONDecoder().decode(JSON.self, from: d!)
    }
}
