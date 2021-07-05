//
//  SettingView.swift
//  BLEcommTest0
//
//  Created by Tadashi Ogino on 2021/01/16.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var log : Log
    @State var uploadfname : String
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Central Mode")
                Spacer()
                Toggle(isOn: $user.CentralMode) {
                    EmptyView()
                }
            }
            HStack {
                Text("Peripheral Mode")
                Spacer()
                Toggle(isOn: $user.PeripheralMode) {
                    EmptyView()
                }
            }
            HStack {
                Text("MyID")
                Spacer()
                TextField("", text: $user.myID,
                          onCommit: {
                            print("onCommit")
                            print(user.myID)
                            UserDefaults.standard.set(user.myID, forKey: "myID")
                          })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("TimerInterval")
                Spacer()
                TextField("", text: $user.timerInterval,
                          onCommit: {
                            print("onCommit")
                            print(user.timerInterval)
                            UserDefaults.standard.set(user.myID, forKey: "myID")
                          })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Button (action: {
                    self.log.upload(fname: uploadfname)
                }) {
                    Text("UploadLog")
                        // テキストのサイズを指定
                        .frame(width: 160, height: 40, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.yellow, lineWidth: 2)
                        )}
                TextField("file name",
                      text: $uploadfname,
                      onCommit: {
                        print("uploadfname:\(uploadfname)")
                      })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button (action: {
                self.log.rmlocal(fname: "NAMI.log")
            }) {
                Text("ClearLog")
                    // テキストのサイズを指定
                    .frame(width: 160, height: 40, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.yellow, lineWidth: 2)
                    )}
        }.padding(5)
        .onAppear(perform: {
            let now = Date() // 現在日時の取得
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP") // ロケールの設定
            dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
            let logfname = dateFormatter.string(from: now)+".log" // -> 20210120195717234.log
            print(logfname)
            uploadfname = logfname
        })
        .onDisappear(perform: {
            print("onDisappear called in SettingView")
            UserDefaults.standard.set(user.myID, forKey: "myID")
            UserDefaults.standard.set(user.timerInterval, forKey: "timerInterval")
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var user = User()
    
    static var previews: some View {
        SettingView( uploadfname: "202107041425000.log")
            .environmentObject(user)
            .environmentObject(Log())
    }
}