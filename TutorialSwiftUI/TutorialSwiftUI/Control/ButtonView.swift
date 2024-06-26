//
//  ButtonView.swift
//  TutorialSwiftUI
//
//  Created by Song Kim on 5/1/24.
//

import SwiftUI
import CodeEditor

struct ButtonView: View {
    @State private var modArr = [TextModifier]()
    
    var body: some View {
        ScrollView {
            VStack {
                
                //View Preview
                VStack(alignment: .leading, spacing: 10) {
                    TitleTextView(title: "View Preview")
                    Text("Button")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    HStack{
                        Spacer()
                        let modifiedText = Button("Button"){}
                            .apply(modifiers: modArr)
                        modifiedText
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                
                //Button
                MenuButton(modArr: $modArr)
                
                
                //CodePreview & List
                VStack(spacing: 20) {
                    TitleTextView(title: "Code Preview")
                    let modifiedCode = generateCode(modifiers: modArr, firstCode: "Button(\"Button\"){}")
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
            .navigationTitle("Button")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func copyCode(_ code: String) {
        UIPasteboard.general.string = code
    }
    
}

#Preview {
    ButtonView()
}
