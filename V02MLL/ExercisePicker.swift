import SwiftUI

struct ExercisePicker: View {
    @Binding var exerciseEntry: ExerciseEntry
    @ObservedObject var exerciseData: ExerciseData

    var body: some View {
        Menu {
            Button(action: { exerciseEntry.exercise = "Rowing" }) {
                Text("Rowing")
            }
            Button(action: { exerciseEntry.exercise = "Pectoral" }) {
                Text("Pectoral")
            }
            Button(action: { exerciseEntry.exercise = "Biceps +" }) {
                Text("Biceps +")
            }
            Button(action: { exerciseEntry.exercise = "Abs" }) {
                Text("Abs")
            }
            Button(action: { exerciseEntry.exercise = "Other" }) {
                Text("Other")
            }
        } label: {
            Text(exerciseEntry.exercise)
                .frame(minWidth: 100)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

struct ExercisePicker_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePicker(exerciseEntry: .constant(ExerciseEntry(exercise: "Rowing", time: "30", date: Date())), exerciseData: ExerciseData())
    }
}
