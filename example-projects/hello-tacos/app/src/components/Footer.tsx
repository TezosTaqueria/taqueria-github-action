const Footer = ({ contractAddress }: { contractAddress: string }) => (
  <footer>
    <div>
      <a
        href="https://github.com/ecadlabs/taquito"
        target="_blank"
        rel="noopener noreferrer nofollow"
      >
        <img src="images/github.svg" alt="github-link" />
      </a>
    </div>
    <div>
      <a
        href={`https://better-call.dev/hangzhou2net/${contractAddress}/operations`}
        target="_blank"
        rel="noopener noreferrer nofollow"
      >
        <img src="images/file-text.svg" alt="contract-link" />
      </a>
    </div>
    <div>
      <a
        href="https://twitter.com/TezosTaquito"
        target="_blank"
        rel="noopener noreferrer nofollow"
      >
        <img src="images/twitter.svg" alt="twitter-link" />
      </a>
    </div>
  </footer>
);

export default Footer;
