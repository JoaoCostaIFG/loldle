import logo from './logo.svg';
import './App.css';
import data from './champions.json' 
import Select from 'react-select'

function App() {
  const champNames = data.map((data) => {
    return (
        {value:data.name, label:data.name}
    )
  })

  return (
    <Select options={champNames}/>
  );
}

export default App;
