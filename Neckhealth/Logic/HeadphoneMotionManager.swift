import CoreMotion
import Combine

class HeadphoneMotionManager: ObservableObject {
    private var motionManager = CMHeadphoneMotionManager()
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var isAvailable: Bool = false
    
    init() {
        checkAvailability()
        startMonitoring()
    }
    
    private func checkAvailability() {
        isAvailable = motionManager.isDeviceMotionAvailable
    }
    
    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Headphone motion is not available")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motion, error in
            guard let self = self,
                  let motion = motion,
                  error == nil else {
                return
            }
            
            // Update the published properties
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
        }
    }
    
    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    deinit {
        stopMonitoring()
    }
}
