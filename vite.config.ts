import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import WindiCSS from "vite-plugin-windicss";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), WindiCSS()],
  server: {
    port: 9001,
    proxy: {
      "/api": {
        target: "https://dev-q-n-a.trap.games/",
        changeOrigin: true,
      },
    },
  },
});
