import React, { useState, useEffect } from "react";
import { TezosToolkit } from "@taquito/taquito";
import BigNumber from "bignumber.js";
import Header from "./components/Header";
import Footer from "./components/Footer";
import Interface from "./components/Interface";
import "./App.css";
import "./styles/Header.css";
import "./styles/Interface.css";
import "./styles/Footer.css";
import "./styles/Wallet.css";

function App() {
  const [rpcUrl, setRpcUrl] = useState("https://hangzhounet.api.tez.ie");
  const [contractAddress, setContractAddress] = useState(
    "KT1C3dq9nqaTKFcbw8hdDFxsaqNruWdX6xde"
  );
  const [contractStorage, setContractStorage] = useState<number | undefined>(
    undefined
  );
  const [Tezos, setTezos] = useState<TezosToolkit>();
  const [connected, setConnected] = useState(false);

  useEffect(() => {
    const contractUrl = require("./contract.txt").default.trim()
    const config = require("./config.json")
    const p = process.env.NODE_ENV !== 'production'
      ? fetch(contractUrl)
        .then(res => res.text())
        .then(contractAddress => contractAddress.trim())
        .then(setContractAddress)
        .then(_ => {
            const env = config.environment.default
            const sandbox = config.environment[env].sandboxes[0]
            const rpcUrl = config.sandbox[sandbox].rpcUrl
            setRpcUrl(rpcUrl)
            return rpcUrl
        })
      : Promise.resolve(rpcUrl)
      p
      .then(async (rpcUrl) => {
        // Setting the toolkit
        const tezos = new TezosToolkit(rpcUrl);
        setTezos(tezos);
        // fetches the contract storage
        const contract = await tezos?.wallet.at(contractAddress);
        const storage: BigNumber | undefined = await contract?.storage();
        if (storage) {
          setContractStorage(storage.toNumber());
        } else {
          setContractStorage(undefined);
        }
      })
  }, [contractAddress])
  return Tezos ? (
    <div className="app">
      <Header
        Tezos={Tezos}
        rpcUrl={rpcUrl}
        setConnected={setConnected}
        connected={connected}
      ></Header>
      <div></div>
      <Interface
        contractStorage={contractStorage}
        setContractStorage={setContractStorage}
        Tezos={Tezos}
        contractAddress={contractAddress}
        connected={connected}
      ></Interface>
      <Footer contractAddress={contractAddress}></Footer>
    </div>
  ) : (
    <div></div>
  );
}

export default App;
