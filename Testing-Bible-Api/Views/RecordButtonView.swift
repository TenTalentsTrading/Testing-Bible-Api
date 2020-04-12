//
//  RecordButtonView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct RecordButtonView: View {
    
    @EnvironmentObject var reference : ScriptureReference

    var body: some View {
        Button(action: {
            self.reference.micButtonTapped()
            self.reference.shouldShowPassage.toggle()
            self.reference.isRecordingSessionActive = true
        }) {
            Image(systemName: !self.reference.micEnabled ? "mic.slash" : (self.reference.isRecording ? "mic.circle.fill" : "mic.circle"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 75)
            }
    }
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordButtonView()
    }
}
