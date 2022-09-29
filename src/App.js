import logo from './logo.svg';
import './App.css';
import data from './champions.json'

function App() {
  const champData = data.map((data) =>{
      return (
        <div key={data.name}>
            {data.name}
        </div>
      )
  })
  return (
    <div className="App">
        {champData}
    </div>
  );
}

export default App;
