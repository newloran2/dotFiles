import ApplicationServices
import Cocoa

// MARK: - Helpers

func getFrontmostWindow() -> AXUIElement? {
   guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
   let appElement = AXUIElementCreateApplication(app.processIdentifier)

   var value: AnyObject?
   let result = AXUIElementCopyAttributeValue(
      appElement, kAXFocusedWindowAttribute as CFString, &value)

   if result == .success {
      return (value as! AXUIElement)
   }

   return nil
}

func getWindowUnderMouse() -> AXUIElement? {
   let mouse = NSEvent.mouseLocation

   // Converter para coordenada do AX (top-left)
   guard let screen = NSScreen.main else { return nil }
   let flippedY = screen.frame.height - mouse.y

   let systemWide = AXUIElementCreateSystemWide()

   var element: AXUIElement?
   let result = AXUIElementCopyElementAtPosition(
      systemWide, Float(mouse.x), Float(flippedY), &element)

   guard result == .success, let el = element else { return nil }

   return findWindow(from: el)
}

func findWindow(from element: AXUIElement) -> AXUIElement? {
   var current: AXUIElement? = element

   while let el = current {
      var roleValue: AnyObject?
      if AXUIElementCopyAttributeValue(el, kAXRoleAttribute as CFString, &roleValue) == .success,
         let role = roleValue as? String,
         role == kAXWindowRole as String
      {
         return el
      }

      var parent: AnyObject?
      if AXUIElementCopyAttributeValue(el, kAXParentAttribute as CFString, &parent) != .success {
         break
      }

      current = (parent as! AXUIElement)
   }

   return nil
}

func setWindowFrame(_ window: AXUIElement, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
   var position = CGPoint(x: x, y: y)
   var size = CGSize(width: w, height: h)

   AXUIElementSetAttributeValue(
      window, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &position)!)
   AXUIElementSetAttributeValue(
      window, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)
}

func getMainScreenFrame() -> CGRect {
   return NSScreen.main!.visibleFrame
}

// MARK: - Movimentos

func moveLeft(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(window, x: s.origin.x, y: s.origin.y, w: s.width / 2, h: s.height)
}

func moveRight(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(window, x: s.origin.x + s.width / 2, y: s.origin.y, w: s.width / 2, h: s.height)
}

func moveUp(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(window, x: s.origin.x, y: s.origin.y, w: s.width, h: s.height / 2)
}

func moveDown(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(window, x: s.origin.x, y: s.origin.y + s.height / 2, w: s.width, h: s.height / 2)
}

func moveUpLeft(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(window, x: s.origin.x, y: s.origin.y, w: s.width / 2, h: s.height / 2)
}

func moveUpRight(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(
      window, x: s.origin.x + s.width / 2, y: s.origin.y, w: s.width / 2, h: s.height / 2)
}

func moveDownLeft(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(
      window, x: s.origin.x, y: s.origin.y + s.height / 2, w: s.width / 2, h: s.height / 2)
}

func moveDownRight(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(
      window, x: s.origin.x + s.width / 2, y: s.origin.y + s.height / 2, w: s.width / 2,
      h: s.height / 2)
}

func moveCenter(window: AXUIElement) {
   let s = getMainScreenFrame()
   let w = s.width * 0.6
   let h = s.height * 0.6

   setWindowFrame(
      window,
      x: s.midX - w / 2,
      y: s.midY - h / 2,
      w: w,
      h: h)
}

func fullscreen(window: AXUIElement) {
   let s = getMainScreenFrame()
   setWindowFrame(
      window,
      x: s.origin.x,
      y: s.origin.y,
      w: s.width,
      h: s.height)
}

// MARK: - Entry

guard AXIsProcessTrusted() else {
   print("⚠️ Dê permissão de Acessibilidade em System Settings → Privacy & Security → Accessibility")
   exit(1)
}

var usePoint = false
var command: String?

for arg in CommandLine.arguments.dropFirst() {
   if arg == "--point" {
      usePoint = true
   } else {
      command = arg
   }
}

guard let cmd = command else {
   print(
      "Uso: win [--point] [left|right|up|down|upLeft|upRight|downLeft|downRight|center|fullscreen]")
   exit(1)
}

let window = usePoint ? getWindowUnderMouse() : getFrontmostWindow()

guard let win = window else {
   print("❌ Não consegui pegar a janela")
   exit(1)
}

switch cmd {
case "left":
   moveLeft(window: win)
case "right":
   moveRight(window: win)
case "up":
   moveUp(window: win)
case "down":
   moveDown(window: win)
case "upLeft":
   moveUpLeft(window: win)
case "upRight":
   moveUpRight(window: win)
case "downLeft":
   moveDownLeft(window: win)
case "downRight":
   moveDownRight(window: win)
case "center":
   moveCenter(window: win)
case "fullscreen":
   fullscreen(window: win)
default:
   print("❌ Comando inválido")
}
