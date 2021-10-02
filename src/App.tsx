/** @jsxImportSource @emotion/react */

import { useState, VFC } from "react";
import { css, keyframes } from "@emotion/react";
import logo from "/logo.svg";

const keyframe = {
  spin: keyframes`
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }`,
};
const style = {
  app: css`
    text-align: center;
    background-color: #282c34;
    min-height: 100vh;
  `,
  header: css`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: calc(10px + 2vmin);
    color: white;
  `,
  logo: css`
    height: 40vmin;
    pointer-events: none;
    @media (prefers-reduced-motion: no-preference) {
      animation: ${keyframe.spin} infinite 20s linear;
    }
  `,
};

const App: VFC = () => {
  const [count, setCount] = useState(0);

  return (
    <div css={style.app}>
      <header className="pt-20" css={style.header}>
        <img src={logo} css={style.logo} alt="logo" />
        <p>Hello Vite + React!</p>
        <p>
          <button
            className="px-2 rounded-md border- button"
            type="button"
            onClick={() => setCount((count) => count + 1)}>
            count is: {count}
          </button>
        </p>
        <p>
          Edit <code>App.tsx</code> and save to test HMR updates.
        </p>
        <p>
          <a
            className="link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer">
            Learn React
          </a>
          {" | "}
          <a
            className="link"
            href="https://vitejs.dev/guide/features.html"
            target="_blank"
            rel="noopener noreferrer">
            Vite Docs
          </a>
        </p>
      </header>
    </div>
  );
};

export default App;
