import { App } from './app';
import { config } from 'dotenv';

const main = async() => {

    config();

    const app = new App();
    await app.listen(process.env.PORT || '7070');

}

main();