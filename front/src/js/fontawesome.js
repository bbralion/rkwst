import { library, dom } from "@fortawesome/fontawesome-svg-core";
import { faCopy } from "@fortawesome/free-solid-svg-icons";

function setupFontAwesome() {
  library.add(faCopy);
  dom.watch();
}

export { setupFontAwesome };
