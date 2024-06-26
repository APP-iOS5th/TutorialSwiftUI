//
//  ContextMenu.swift
//  TutorialSwiftUI
//
//  Created by Song Kim on 5/1/24.
//

import SwiftUI
import CodeEditor

private let menuItems = ContextMenu {
    Button ("Button1",systemImage: "heart"){}
    Button ("Button2"){}
}

struct ContextMenuView: View {
    @State private var ShowMenu = true
    @State private var modArr = [TextModifier]()
    
    var body: some View {
        ScrollView {
            VStack {
                
                //View Preview
                VStack(alignment: .leading, spacing: 10) {
                    TitleTextView(title: "View Preview")
                    Text("ContextMenu")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    HStack{
                        Spacer()
                        let modifiedText = Text("Turtle Rock")
                            .apply(modifiers: modArr)
                        modifiedText
                            .contextMenu(ShowMenu ? menuItems : nil)
                            .frame(minHeight: 100)
                            .font(.largeTitle)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
    
                
                //Button
                MenuButton(modArr: $modArr)
                
                
                //CodePreview
                VStack(spacing: 20) {
                    TitleTextView(title: "Code Preview")
                    let modifiedCode = generateCode(modifiers: modArr, firstCode: """
                            private let menuItems = ContextMenu {
                            Button(\"btn\",systemImage:\"heart\"){}
                            Button(\"btn\"){}
                        }
                        Text(\"Turtle Rock\")
                        .contextMenu(ShowMenu ? menuItem : nil)
                        """)
                    CodePreviewView(code: modifiedCode, copyAction: copyCode, showCopy: true)
                    
                    TitleTextView(title: "List")
                    AddListView(modArr: $modArr)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
            }
            
            .padding()
            .frame(maxHeight: .infinity)
            .navigationTitle("ContextMenu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func copyCode(_ code: String) {
        UIPasteboard.general.string = code
    }
}

#Preview {
    ContextMenuView()
}
