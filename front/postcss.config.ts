import tailwindcss from "tailwindcss";
import tailwindConfig from "./tailwind.config";
import autoprefixer from "autoprefixer";

export default {
  plugins: [tailwindcss(tailwindConfig), autoprefixer()],
};
