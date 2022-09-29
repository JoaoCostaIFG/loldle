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

  const onKeyDown = e => {
    if (e.keyCode === 13) {
      // do stuff
      alert("you have pressed enter");
    }
  };

  return (
    <Select options={champNames}
    onKeyDown={onKeyDown}/>
  );
}

export default App;
