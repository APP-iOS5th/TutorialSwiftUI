//
//  StepperView.swift
//  TutorialSwiftUI
//
//  Created by Song Kim on 5/1/24.
//

import SwiftUI
import CodeEditor

struct StepperView: View {
    @State private var sleepAmount = 0.0
    @State private var modArr = [TextModifier]()
    
    var body: some View {
        VStack {
            // 선택된 수정자를 적용한 텍스트 뷰
                Stepper(value: $sleepAmount) {
                            Text("\(sleepAmount)")
                        }
                    .apply(modifiers: modArr)
                .padding()
                .frame(minHeight: 100)
                .font(.largeTitle)
            
            // 선택된 수정자를 적용한 텍스트 뷰
            let modifiedCode = generateCode(modifiers: modArr, firstCode: """
            Stepper(value: $amount){
                Text(\"amount\")
            }
            """
            )
            VStack(alignment: .leading) {
                CodeEditor(
                    source: modifiedCode,
                    language: .javascript,
                    theme: .agate
                )
            }
            .cornerRadius(10)
            .padding([.trailing, .leading, .bottom])
            
            MenuButton(modArr: $modArr)
            
            // 선택된 수정자를 나열한 리스트
            List {
                ForEach(modArr.indices, id: \.self) { index in
                    Text("🜸 \(modArr[index].description)")
                }
                .onDelete(perform: { indexSet in
                    modArr.remove(atOffsets: indexSet)
                })
            }
            .scrollContentBackground(.hidden)
            .frame(height: 400)
        }
    }
}

#Preview {
    StepperView()
}
