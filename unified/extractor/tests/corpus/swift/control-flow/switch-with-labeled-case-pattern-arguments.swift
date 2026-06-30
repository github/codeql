switch x {
case .implicit(isAcknowledged: false):
  print("yes")
case .thread(threadRowId: _, let rowId):
  print(rowId)
}
