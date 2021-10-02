import { VFC } from "react";
import { BrowserRouter } from "react-router-dom";
import { Route, Switch } from "react-router";
import Settings from "../components/Settings";
import Main from "../components/Main";

const Router: VFC = () => {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/" exact>
          <Main />
        </Route>
        <Route path="/settings">
          <Settings />
        </Route>
      </Switch>
    </BrowserRouter>
  );
};

export default Router;
