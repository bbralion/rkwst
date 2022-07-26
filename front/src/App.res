@react.component
let make = () => {
  <div className="grid grid-cols-1">
    <header> <nav className="bg-slate-700 h-16" /> </header>
    <main className="min-h-screen bg-slate-200"> <BinPage.Index /> </main>
  </div>
}
