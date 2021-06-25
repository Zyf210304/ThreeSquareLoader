//
//  Home.swift
//  ThreeSquareLoader
//
//  Created by 张亚飞 on 2021/6/25.
//

import SwiftUI

struct Home: View {
    
    
    //animation properties
    @State var offsets: [CGSize] = Array(repeating: .zero, count: 3)
    
    //static offsets for one full complete rotation
    
    // so after one complete roatation it will again fire animation
    // for that were going to use timer..
    
    //just cancel timer when new page open or closed...
    @State var timer = Timer.publish(every: 4, on: .current, in: .common).autoconnect()
    
    @State var delayTime : Double = 0
    
    var locations: [CGSize] = [
    
        // rotation1
        CGSize(width: 110, height: 0),
        CGSize(width: 0, height: -110),
        CGSize(width: -110, height: 0),
        // rotation2
        CGSize(width: 110, height: 110),
        CGSize(width: 110, height: -110),
        CGSize(width: -110, height: -110),
        // rotation3
        CGSize(width: 0, height: 110),
        CGSize(width: 110, height: 0),
        CGSize(width: 0, height: -110),
        //final reseting rotation....
        CGSize(width: 0, height: 0),
        CGSize(width: 0, height: 0),
        CGSize(width: 0, height: 0),
    ]
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            
            VStack {
                
                HStack( spacing: 10) {
                    
                    Rectangle()
                        .fill(Color("box1"))
                        .frame(width: 100, height: 100)
                        .offset(offsets[0])
                }
                .frame(width: 210, alignment: .leading)
                
                HStack( spacing: 10) {
                    
                    Rectangle()
                        .fill(Color("box2"))
                        .frame(width: 100, height: 100)
                        .offset(offsets[1])
                    
                    Rectangle()
                        .fill(Color("box3"))
                        .frame(width: 100, height: 100)
                        .offset(offsets[2])
                }
            }
        }
        .onAppear {
            
            doAnimation()
        }
        .onReceive(timer) { _ in
            
            print("re Do anitation")
            delayTime = 0
            doAnimation()
        }
    }
    
    func  doAnimation() {
        
        //doing our animation here...
        
        //since we have three offsets so were going to convert this array to subarrays of mx three elements
        //you can directly declare as subarrays..
        //Im doing like this its you choice
        
        var tempOffsets: [[CGSize]] = []
        var currentSet: [CGSize] = []
        for value in locations {
            
            currentSet.append(value)
            
            if currentSet.count == 3 {
                
                tempOffsets.append(currentSet)
                
                currentSet.removeAll()
            }
        }
        
        if !currentSet.isEmpty {
            
            tempOffsets.append(currentSet)
            currentSet.removeAll()
        }
        
        for offset in tempOffsets {
            
            for index in offset.indices {
                
                //each box shift will take 0.5 sec to finish...
                //so delay will be 0.3 and its multiplies
                doAnimation(delay:.now() + delayTime, value: offset[index], index: index)
                delayTime += 0.3
            }
        }
        
    }
    
    
    func  doAnimation(delay: DispatchTime, value: CGSize, index: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                
                self.offsets[index] = value
            }
        }
        
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
