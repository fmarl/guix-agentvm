import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const shellWord = String.raw`(?:"[^"]*"|'[^']*'|\S+)`;
const gitOption = String.raw`(?:-[Cc]\s*${shellWord}|--(?:git-dir|work-tree|namespace)\s+${shellWord}|--?[\w-]+(?:=${shellWord})?)`;

const needsConfirmation = [
  new RegExp(String.raw`\bgit\b(?:\s+${gitOption})*\s+(?:commit|merge|cherry-pick|revert|am|push|pull)\b`),
  /\bgh\s+(?:pr\s+(?:create|merge)|api)\b/,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash") return;

    const command = (event.input as { command?: unknown }).command;
    if (typeof command !== "string" || !needsConfirmation.some((pattern) => pattern.test(command))) return;

    if (!ctx.hasUI) return { block: true, reason: "Needs the user's confirmation, and there is no UI to ask in." };

    if (!(await ctx.ui.confirm("Run this command?", command))) {
      return { block: true, reason: "The user declined." };
    }
  });
}
