/*
 HighlightSwift : https://github.com/appstefan/highlightswift.git
 CodeEditor : https://github.com/ZeeZide/CodeEditor.git
 */

import SwiftUI
import HighlightSwift
import CodeEditor

/// Picker에서 사용할 속성, HStack의 Alignment 속성
private enum AlignmentHStack: String, CaseIterable  {
    case center, top, bottom
    
    func toAlignment() -> VerticalAlignment {
        switch self {
        case .center:
            return .center
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

/// Picker에서 사용할 속성, HStack의 Spacing 속성
private enum SpacingHStack: String, CaseIterable {
    case none = "nil", five = "5", ten = "10", twenty = "20"
    
    func toCGFloat() -> CGFloat? {
        switch self {
        case .none:
            return nil
        case .five:
            return 5
        case .ten:
            return 10
        case .twenty:
            return 20
        }
    }
}

/// Code의 소스를 출력하기 위한 구조체
private struct CodeSource {
    /// 기본 대상
    var original:String = """
HStack (alignment: .center,spacing: nil){
    Text(\"Hello\")
        .border(Color.black)
        .font(.system(size: 33))
    Text(\"AppSchool\")
        .border(Color.black)
        .font(.system(size: 22))
    Text(\"Tutorial Project\")
        .border(Color.black)
        .font(.system(size: 11))
}
"""
    /// 모디파이어 텍스트
    var text:[String] = Array(repeating: "", count: pickerCount)
    
    /// original과 text 배열을 연결한 문자열
    var toString: String {
        print("CodeSource - \(text)") // 로그
        return original + text.joined()
    }
}

/// Code의 설명을 출력하기 위한 구조체
private struct CodeDescription {
    /// 기본 대상
    var original:String = """
HStack : 내부의 View들을 수평(가로)으로 배치
Alignment : 내부의 View들을 정렬
Spacing : 내부의 View들 사이의 간격을 조정
"""
    
    /// 모디파이어 텍스트
    var text:[String] = Array(repeating: "", count: pickerCount)
    
    /// original과 text 배열을 연결한 문자열
    var toString: String {
        print("CodeDescription - \(text)") // 로그
        return original + text.joined()
    }
}

/// 사용할 모디파이어 기재
private enum Modifire: String, CaseIterable {
    case none, bold, frame, background, padding, foregroundColor
    
    /// 코드 설명
    var description: String {
        switch self {
        case .none: return ""
        case .bold: return "\nbold : HStack 내부 View들의 글씨를 두껍게"
        case .frame: return "\nframe : HStack의 크기 설정"
        case .background: return "\nbackground : HStack의 배경 스타일 설정"
        case .padding: return "\npadding : HStack의 안쪽에 여백 설정"
        case .foregroundColor: return "\nforegroundColor: HStack 내부 View들의 글자색 지정"
        }
    }
    
    /// 코드 소스
    var code: String {
        switch self {
        case .none: return ""
        case .bold: return "\n.bold()"
        case .frame: return "\n.frame(width: 300, height: 100)"
        case .background: return "\n.background(Color.red)"
        case .padding: return "\n.padding(20)"
        case .foregroundColor: return "\n.foregroundColor(.blue)"
        }
    }
}

/// 코드 결과 - 부여할 모디파이어 설정
private struct ModifireBuilder: ViewModifier {
    @Binding var selectedModifire: Modifire
    
    func body(content: Content) -> some View {
        switch selectedModifire {
        case .none : content
        case .bold : content.bold()
        case .frame : content.frame(width: 300, height: 100)
        case .background : content.background(Color.red)
        case .padding : content.padding(20)
        case .foregroundColor : content.foregroundColor(.blue)
        }
    }
}

/// - picker의 개수 (개수에 맞춰 설정 필수)
/// - CodeSource, CodeDescription 및 selectedModifire의 repeating에 사용
private let pickerCount = 3

/// # body View
struct HStackView: View {
    /// Picker의 제목 배열
    private let pickerTitle: [String] = [
        "First", "Second", "Third"
    ]
    
    /// 각각의 Picker에서 선택될 enum 타입의 모디파이어 배열
    @State private var selectedModifire: [Modifire] =
    Array(repeating: .none, count: pickerCount)
    
    /// Picker에서 선택될 VStack의 Alignment 속성
    @State private var selectedAlignment: AlignmentHStack = .center
    
    /// Picker에서 선택될 VStack의 Spacing 속성
    @State private var selectedSpacing: SpacingHStack = .none
    
    /// 코드의 소스 구조체
    @State private var codeSource = CodeSource()
    
    /// 코드의 설명문 구조체
    @State private var codeDescription = CodeDescription()
    
    /// # 리스트용 PickerView
    /// - 설명
    ///     - ForEach : Enum 타입의 Modifire순회 & Picker의 Content 생성
    ///     - OnChange : Picker 선택시, 해당 위치의 값 수정
    /// - 인자
    ///     - i : index
    private func PickerView(_ i: Int) -> some View {
        return HStack {
            Text(pickerTitle[i])
            Spacer()
            Picker(
                pickerTitle[i],
                selection: $selectedModifire[i]
            ) {
                ForEach(
                    Modifire.allCases,
                    id: \.self
                ) {
                    item in
                    Text("\(item.rawValue)").tag(item)
                }
            }.onChange(
                of: selectedModifire
            ) {
                old, new in
                codeSource.text[i] = new[i].code
                codeDescription.text[i] = new[i].description
            }
        }
        
    }
    
    /// # 리스트용 PickerView
    /// - HStack의 Alignment 설정
    private func PickerAlignmentView() -> some View {
        return HStack {
            Text("Alignment")
            Spacer()
            Picker(
                "Alignment",
                selection: $selectedAlignment
            ) {
                ForEach(
                    AlignmentHStack.allCases,
                    id: \.self
                ) {
                    item in
                    Text("\(item.rawValue)").tag(item)
                }
            }.onChange(
                of: selectedAlignment
            ) {
                old, new in
                codeSource.original = codeSource.original
                    .replacingOccurrences(
                        of: "alignment: .\(old.rawValue)",
                        with: "alignment: .\(new.rawValue)"
                    )
            }
        }
    }
    
    /// # 리스트용 PickerView
    /// - VStack의 Spacing 설정
    private func PickerSpacingView() -> some View {
        return HStack {
            Text("Spacing")
            Spacer()
            Picker(
                "Spacing",
                selection: $selectedSpacing
            ) {
                ForEach(
                    SpacingHStack.allCases
                    ,id: \.self
                ) {
                    item in
                    Text("\(item.rawValue)").tag(item)
                }
            }.onChange(
                of: selectedSpacing
            ) {
                old, new in
                codeSource.original = codeSource.original
                    .replacingOccurrences(
                        of: "spacing: \(old.rawValue)",
                        with: "spacing: \(new.rawValue)")
            }
        }
    }
    
    /// # 영역 - 코드의 실행 결과를 보여줌
    private var viewPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            TitleTextView(title: "View Preview")
            
            Divider()
            HStack{
                Spacer()
                HStack(
                    alignment: selectedAlignment.toAlignment(),
                    spacing: selectedSpacing.toCGFloat()
                ) {
                    Text("Hello")
                        .border(Color.black)
                        .font(.system(size: 33))
                    Text("AppSchool")
                        .border(Color.black)
                        .font(.system(size: 22))
                    Text("Tutorial Project")
                        .border(Color.black)
                        .font(.system(size: 11))
                }
                .modifier(ModifireBuilder(selectedModifire: $selectedModifire[0]))
                .modifier(ModifireBuilder(selectedModifire: $selectedModifire[1]))
                .modifier(ModifireBuilder(selectedModifire: $selectedModifire[2]))
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    /// # 영역 - 코드의 프리뷰를 보여줌
    private var codePreviewSection: some View {
        VStack(spacing: 20) {
            TitleTextView(title: "Code Preview")
            CodePreviewView(code: returnCode(), copyAction: copyCode, showCopy: true)
            
            TitleTextView(title: "Code Descrption")
            CodePreviewView(code: basecode(), copyAction: copyCode, showCopy: false)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    /// Base code
    func basecode() -> String {
        return codeDescription.toString
    }
    
    ///
    func copyCode(_ code: String) {
        UIPasteboard.general.string = code
    }
    
    ///
    func returnCode() -> String {
        return codeSource.toString
    }
    
    /// # 영역 - 옵션, 모디파이어 선택
    private var optionSelectSection: some View {
        VStack {
            TitleTextView(title: "Option Select")
            /// ## Picker 리스트
            
            Section(header: Text("Option")) {
                PickerAlignmentView()
                PickerSpacingView()
            }
            
            Section(header: Text("Modifire")) {
                PickerView(0)
                PickerView(1)
                PickerView(2)
            }
        }.padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
    
    /// # body
    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                viewPreviewSection
                optionSelectSection
                codePreviewSection
            }
            .padding()
            .frame(maxHeight: .infinity)
            .navigationTitle("HStack View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HStackView()
}
