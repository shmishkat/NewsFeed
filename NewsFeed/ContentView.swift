//
//  ContentView.swift
//  NewsFeed
//
//  Created by Sarowar H. Mishkat on 3/3/20.
//  Copyright © 2020 Sarowar H. Mishkat. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import BottomBar_SwiftUI
import WebKit


let items: [BottomBarItem] = [
    BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
    BottomBarItem(icon: "star", title: "Favorite", color: .pink),
    BottomBarItem(icon: "slider.horizontal.3", title: "Settings", color: .gray),
]

struct ContentView: View {
    
    @State private var selectedIndex = 0
    @ObservedObject var list = getData()
    
    var body: some View {
        
        NavigationView{
            
            List(list.data){ i in
                
                NavigationLink(destination:
                webView(url: i.url)
                    .navigationBarTitle("",displayMode: .inline)){
                        
                    HStack{
                        VStack(alignment: .leading, spacing: 10){
                            Text(i.title).fontWeight(.heavy)
                            Text(i.description).lineLimit(2).font(.body)
                            
                        }
                        if i.image != ""{
                             
                          WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                            .resizable()
                            .frame(width: 110, height: 80)
                            .cornerRadius(10)
                            
                        }
                       
                        
                    }.padding(.vertical, 10)
                }
                

            }.navigationBarTitle("News")
        }
        .padding()
        
    }
}



struct datatypes : Identifiable{
    var id : String
    var title : String
    var description : String
    var url : String
    var image : String
}

class getData : ObservableObject{
    
    @Published var data = [datatypes]()
    
    init(){
        
        let source = "http://newsapi.org/v2/everything?domains=wsj.com&apiKey=8b441f843fb04b68a16ad1ee49fcc490"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                DispatchQueue.main.async {
                    self.data.append(datatypes(id: id, title: title, description: description, url: url, image: image))
                }
                
            }
            
            
        }.resume()
        
    }
}

struct webView: UIViewRepresentable{
    
    var url: String
    
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>) {
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
